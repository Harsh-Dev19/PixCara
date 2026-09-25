/// Represents a single pose in the pose library.
///
/// A [PoseModel] can come from two places:
/// - the local bundled/dummy library (uses [imageAsset])
/// - a Pexels search result (uses [imageUrl], plus attribution fields)
///
/// The UI never touches raw Pexels JSON — [PoseModel.fromPexelsJson]
/// is the only place that translates the API response into this
/// clean, app-specific shape.
class PoseModel {
  final String id;
  final int poseNumber;
  final String name;
  final String category;
  final String description;

  /// Local bundled asset path. Empty for Pexels-sourced poses.
  final String imageAsset;

  /// Remote photo URL (Pexels). Null for local poses.
  final String? imageUrl;

  /// Attribution, required whenever a pose comes from Pexels.
  final String? photographer;
  final String? photographerUrl;

  /// Link to the original photo page on pexels.com.
  final String? sourceUrl;

  bool isFavorite;

  PoseModel({
    required this.id,
    required this.poseNumber,
    required this.name,
    required this.category,
    required this.description,
    this.imageAsset = '',
    this.imageUrl,
    this.photographer,
    this.photographerUrl,
    this.sourceUrl,
    this.isFavorite = false,
  });

  /// True if this pose came from Pexels rather than the local library.
  bool get isRemote => imageUrl != null && imageUrl!.isNotEmpty;

  /// Maps one entry of Pexels' `photos` array into a [PoseModel].
  ///
  /// [poseNumber] is assigned by the caller (the service) based on the
  /// item's position across the whole search, not the raw Pexels id,
  /// so the pose preview screen shows a clean sequential number.
  factory PoseModel.fromPexelsJson(
    Map<String, dynamic> json, {
    required String searchQuery,
    required int poseNumber,
  }) {
    final src = json['src'] as Map<String, dynamic>? ?? const {};
    // 'large' is a good balance of quality vs. size for both the grid
    // thumbnail and the preview screen — nowhere near the full original.
    final imageUrl =
        (src['large'] ?? src['medium'] ?? src['original']) as String?;

    return PoseModel(
      id: 'pexels_${json['id']}',
      poseNumber: poseNumber,
      name: _titleCase(searchQuery),
      category: searchQuery,
      description: 'Pose reference for "$searchQuery".',
      imageUrl: imageUrl,
      photographer: json['photographer'] as String?,
      photographerUrl: json['photographer_url'] as String?,
      sourceUrl: json['url'] as String?,
    );
  }

  static String _titleCase(String text) {
    return text
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
