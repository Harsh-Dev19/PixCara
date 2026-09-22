import 'package:flutter/material.dart';
import '../data/pose_data.dart';
import '../models/pose_model.dart';
import '../theme/app_colors.dart';
import '../widgets/category_chip.dart';
import '../widgets/pose_card.dart';
import 'pose_preview_screen.dart';

/// POSE LIBRARY screen — search, filter by category, and browse poses.
class PoseLibraryScreen extends StatefulWidget {
  const PoseLibraryScreen({super.key});

  @override
  State<PoseLibraryScreen> createState() => _PoseLibraryScreenState();
}

class _PoseLibraryScreenState extends State<PoseLibraryScreen> {
  String _searchQuery = '';
  String? _selectedCategory;

  List<PoseModel> get _filteredPoses {
    return dummyPoses.where((pose) {
      final matchesCategory =
          _selectedCategory == null || pose.category == _selectedCategory;
      final matchesSearch =
          pose.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _openPosePreview(PoseModel pose) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PosePreviewScreen(pose: pose)),
    );
  }

  void _toggleFavorite(PoseModel pose) {
    setState(() => pose.isFavorite = !pose.isFavorite);
  }

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
          Expanded(child: _buildPoseGrid()),
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
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Search poses',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
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
            onTap: () {
              setState(() {
                _selectedCategory = isSelected ? null : category;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildPoseGrid() {
    final poses = _filteredPoses;

    if (poses.isEmpty) {
      return const Center(
        child: Text(
          'No poses found',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      itemCount: poses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final pose = poses[index];
        return PoseCard(
          pose: pose,
          onTap: () => _openPosePreview(pose),
          onFavoriteToggle: () => _toggleFavorite(pose),
        );
      },
    );
  }
}
