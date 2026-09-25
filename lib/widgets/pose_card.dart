import 'package:flutter/material.dart';
import '../models/pose_model.dart';
import '../theme/app_colors.dart';
import 'pose_placeholder_image.dart';

/// A single pose thumbnail card shown in the Pose Library grid.
class PoseCard extends StatelessWidget {
  final PoseModel pose;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const PoseCard({
    super.key,
    required this.pose,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PosePlaceholderImage(
            imageAsset: pose.imageAsset,
            imageUrl: pose.imageUrl,
            borderRadius: BorderRadius.circular(14),
          ),
          // Subtle bottom gradient so the label stays readable.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            right: 8,
            child: Text(
              pose.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: onFavoriteToggle,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  pose.isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                  color: pose.isFavorite ? AppColors.gold : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
