import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Displays the real pose image if the asset exists, otherwise falls
/// back to a simple stylized placeholder so the UI still looks
/// intentional before real pose photography is added.
class PosePlaceholderImage extends StatelessWidget {
  final String imageAsset;
  final BorderRadius borderRadius;

  const PosePlaceholderImage({
    super.key,
    required this.imageAsset,
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
        child: Image.asset(
          imageAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Asset not bundled yet — show a neutral placeholder icon
            // instead of crashing or showing Flutter's default error box.
            return const Center(
              child: Icon(
                Icons.person_outline,
                color: AppColors.textSecondary,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}
