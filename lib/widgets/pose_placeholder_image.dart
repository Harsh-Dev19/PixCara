import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Displays a pose image from whichever source is available:
/// a remote [imageUrl] (Pexels) first, then a local [imageAsset],
/// then a neutral placeholder icon if neither loads.
class PosePlaceholderImage extends StatelessWidget {
  final String imageAsset;
  final String? imageUrl;
  final BorderRadius borderRadius;

  const PosePlaceholderImage({
    super.key,
    this.imageAsset = '',
    this.imageUrl,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surfaceLight, AppColors.surface],
          ),
        ),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
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
        },
        errorBuilder: (context, error, stackTrace) => _fallbackIcon(),
      );
    }

    if (imageAsset.isNotEmpty) {
      return Image.asset(
        imageAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackIcon(),
      );
    }

    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    return const Center(
      child: Icon(
        Icons.person_outline,
        color: AppColors.textSecondary,
        size: 40,
      ),
    );
  }
}
