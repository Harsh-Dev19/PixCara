import 'package:flutter/material.dart';
import '../models/pose_model.dart';
import '../theme/app_colors.dart';

/// Placeholder for the future Overlay Camera screen.
///
/// This is where the selected pose will be shown as a transparent
/// overlay on top of the live camera feed, without appearing in the
/// final captured photo. Real camera + overlay logic is implemented
/// in a later development stage.
class OverlayCameraScreen extends StatelessWidget {
  final PoseModel pose;

  const OverlayCameraScreen({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Overlay Camera — ${pose.name}')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.camera_outlined,
                color: AppColors.textSecondary,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Overlay camera for "${pose.name}" coming soon',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
