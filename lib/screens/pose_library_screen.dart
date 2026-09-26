import 'dart:async';
import 'package:flutter/material.dart';
import '../data/pose_data.dart';
import '../models/pose_model.dart';
import '../services/pexels_service.dart';
import '../theme/app_colors.dart';
import '../widgets/category_chip.dart';
import '../widgets/pose_card.dart';
import 'pose_preview_screen.dart';

/// What the library is currently showing.
enum _LibraryStatus { browsingLocal, loading, loaded, empty, error }

/// POSE LIBRARY screen.
///
/// With an empty search and no category selected, this shows the local
/// curated pose list (unchanged from before). Typing a search or
/// tapping a category chip searches Pexels for pose reference photos.
class PoseLibraryScreen extends StatefulWidget {
  const PoseLibraryScreen({super.key});

  @override
  State<PoseLibraryScreen> createState() => _PoseLibraryScreenState();
}

class _PoseLibraryScreenState extends State<PoseLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  String? _selectedCategory;
  _LibraryStatus _status = _LibraryStatus.browsingLocal;

  List<PoseModel> _results = [];
  String _activeQuery = '';
  int _page = 1;
  bool _hasMore = false;
  bool _isLoadingMore = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ---- Search / category handling ----------------------------------

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        setState(() {
          _status = _LibraryStatus.browsingLocal;
          _selectedCategory = null;
          _results = [];
        });
        return;
      }
      setState(() => _selectedCategory = null);
      _runSearch(trimmed);
    });
    setState(() {}); // updates the clear button visibility immediately
  }

  /// Clears the search field and immediately reverts to the local pose
  /// grid, without waiting out the debounce used for typed input.
  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {
      _status = _LibraryStatus.browsingLocal;
      _selectedCategory = null;
      _results = [];
    });
  }

  void _onCategoryTap(String category) {
    _debounce?.cancel();
    final isSame = _selectedCategory == category;

    if (isSame) {
      setState(() {
        _selectedCategory = null;
        _status = _LibraryStatus.browsingLocal;
        _searchController.clear();
      });
      return;
    }

    setState(() => _selectedCategory = category);
    _searchController.clear();
    _runSearch('$category pose');
  }

  Future<void> _runSearch(String query) async {
    setState(() {
      _status = _LibraryStatus.loading;
      _activeQuery = query;
      _page = 1;
      _hasMore = false;
      _results = [];
      _errorMessage = '';
    });

    try {
      final result = await PexelsService.instance.search(query: query, page: 1);
      if (!mounted || query != _activeQuery) return; // a newer search won
      setState(() {
        _results = result.poses;
        _hasMore = result.hasMore;
        _status =
            result.poses.isEmpty ? _LibraryStatus.empty : _LibraryStatus.loaded;
      });
    } catch (e) {
      if (!mounted || query != _activeQuery) return;
      setState(() {
        _status = _LibraryStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    final nextPage = _page + 1;
    try {
      final result =
          await PexelsService.instance.search(query: _activeQuery, page: nextPage);
      if (!mounted) return;
      setState(() {
        _results = [..._results, ...result.poses];
        _hasMore = result.hasMore;
        _page = nextPage;
      });
    } catch (_) {
      // Load-more failures stay silent — the user already has results
      // on screen; they can scroll again to retry.
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _onScroll() {
    if (_status != _LibraryStatus.loaded || !_hasMore || _isLoadingMore) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  void _toggleFavorite(PoseModel pose) {
    setState(() => pose.isFavorite = !pose.isFavorite);
  }

  void _openPosePreview(PoseModel pose) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PosePreviewScreen(pose: pose)),
    );
  }

  // ---- UI -------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pose Library')),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildCategoryChips(),
          const SizedBox(height: 12),
          Expanded(child: _buildBody()),
          if (_status != _LibraryStatus.browsingLocal) _buildAttributionFooter(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search poses (e.g. "standing pose")',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: _clearSearch,
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: poseCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = poseCategories[index];
          final isSelected = _selectedCategory == category;
          return CategoryChip(
            label: category,
            isSelected: isSelected,
            onTap: () => _onCategoryTap(category),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _LibraryStatus.browsingLocal:
        return _buildLocalGrid();
      case _LibraryStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        );
      case _LibraryStatus.loaded:
        return _buildResultsGrid();
      case _LibraryStatus.empty:
        return _buildEmptyState();
      case _LibraryStatus.error:
        return _buildErrorState();
    }
  }

  Widget _buildLocalGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      itemCount: dummyPoses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final pose = dummyPoses[index];
        return PoseCard(
          pose: pose,
          onTap: () => _openPosePreview(pose),
          onFavoriteToggle: () => _toggleFavorite(pose),
        );
      },
    );
  }

  Widget _buildResultsGrid() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      itemCount: _results.length + (_isLoadingMore ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        if (index >= _results.length) {
          return const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.gold,
              ),
            ),
          );
        }
        final pose = _results[index];
        return PoseCard(
          pose: pose,
          onTap: () => _openPosePreview(pose),
          onFavoriteToggle: () => _toggleFavorite(pose),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'No poses found for "$_activeQuery"',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_outlined,
              color: AppColors.textSecondary,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _runSearch(_activeQuery),
              child: const Text('Retry', style: TextStyle(color: AppColors.gold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributionFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        'Photos provided by Pexels',
        style: const TextStyle(color: AppColors.textDisabled, fontSize: 11),
      ),
    );
  }
}