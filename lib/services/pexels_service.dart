import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';
import '../models/pose_model.dart';

/// Thrown for any Pexels request problem, with a message that's
/// already safe/readable to show directly in the UI.
class PexelsException implements Exception {
  final String message;
  PexelsException(this.message);

  @override
  String toString() => message;
}

/// One page of search results, already mapped to [PoseModel].
class PexelsSearchResult {
  final List<PoseModel> poses;
  final bool hasMore;

  PexelsSearchResult({required this.poses, required this.hasMore});
}

/// Talks to the Pexels "search photos" endpoint and maps results into
/// [PoseModel]s. This is PIXCARA's only source of pose *reference*
/// photos — it is not a general photo-browsing feature.
///
/// Docs: https://www.pexels.com/api/documentation/
class PexelsService {
  PexelsService._internal();
  static final PexelsService instance = PexelsService._internal();

  static const String _baseUrl = 'https://api.pexels.com/v1/search';
  static const int perPage = 24;

  /// Simple in-memory cache keyed by "query|page" so re-running the
  /// same search (e.g. reselecting a category) doesn't spend an extra
  /// API request. Cleared automatically when the app restarts.
  final Map<String, PexelsSearchResult> _cache = {};

  Future<PexelsSearchResult> search({
    required String query,
    int page = 1,
  }) async {
    if (!Env.hasPexelsKey) {
      throw PexelsException(
        'Pexels API key is missing. Add it locally — see README setup steps.',
      );
    }

    final normalizedQuery = query.trim().toLowerCase();
    final cacheKey = '$normalizedQuery|$page';
    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'query': query,
      'orientation': 'portrait',
      'per_page': perPage.toString(),
      'page': page.toString(),
    });

    http.Response response;
    try {
      response = await http.get(
        uri,
        headers: {'Authorization': Env.pexelsApiKey},
      );
    } catch (_) {
      throw PexelsException('Could not reach Pexels. Check your connection.');
    }

    if (response.statusCode == 401) {
      throw PexelsException('Pexels rejected the API key (401 Unauthorized).');
    }
    if (response.statusCode == 429) {
      throw PexelsException('Pexels rate limit reached. Try again shortly.');
    }
    if (response.statusCode != 200) {
      throw PexelsException('Pexels request failed (${response.statusCode}).');
    }

    Map<String, dynamic> json;
    try {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw PexelsException('Received an unexpected response from Pexels.');
    }

    final photos = (json['photos'] as List<dynamic>?) ?? const [];
    final totalResults = (json['total_results'] as int?) ?? 0;

    final poses = <PoseModel>[];
    for (var i = 0; i < photos.length; i++) {
      final globalIndex = (page - 1) * perPage + i + 1;
      poses.add(PoseModel.fromPexelsJson(
        photos[i] as Map<String, dynamic>,
        searchQuery: query,
        poseNumber: globalIndex,
      ));
    }

    final hasMore = photos.isNotEmpty && (page * perPage) < totalResults;

    final result = PexelsSearchResult(poses: poses, hasMore: hasMore);
    _cache[cacheKey] = result;
    return result;
  }

  /// Clears the in-memory result cache. Not called automatically —
  /// available if you ever add a manual "refresh" action.
  void clearCache() => _cache.clear();
}
