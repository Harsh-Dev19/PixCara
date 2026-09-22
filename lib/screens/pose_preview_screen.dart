import 'package:flutter/material.dart';
import '../models/pose_model.dart';
import '../theme/app_colors.dart';
import '../widgets/pose_placeholder_image.dart';
import 'overlay_camera_screen.dart';

/// POSE PREVIEW screen — full pose detail shown before shooting.
class PosePreviewScreen extends StatefulWidget {
  final PoseModel pose;

  const PosePreviewScreen({super.key, required this.pose});

  @override
  State<PosePreviewScreen> createState() => _PosePreviewScreenState();
}

class _PosePreviewScreenState extends State<PosePreviewScreen> {
  void _toggleFavorite() {
    setState(() => widget.pose.isFavorite = !widget.pose.isFavorite);
  }

  void _useThisPose() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OverlayCameraScreen(pose: widget.pose),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pose = widget.pose;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: PosePlaceholderImage(imageAsset: pose.imageAsset),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _RoundIconButton(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.pop(context),
                        ),
                        _RoundIconButton(
                          icon: pose.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          iconColor:
                              pose.isFavorite ? AppColors.gold : Colors.white,
                          onTap: _toggleFavorite,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'POSE ${pose.poseNumber.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pose.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        pose.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _useThisPose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'USE THIS POSE',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
