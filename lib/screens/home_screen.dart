import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'pose_library_screen.dart';

/// HOME / CAMERA screen.
///
/// Shows a placeholder camera preview until the real camera
/// implementation is wired up in a later development stage.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFrontCamera = false;

  void _toggleCamera() {
    setState(() => _isFrontCamera = !_isFrontCamera);
  }

  void _openPoseLibrary() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PoseLibraryScreen()),
    );
  }

  void _onCapture() {
    // Placeholder — real capture logic is added in a later stage.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Capture not implemented yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildCameraPreview()),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'PIXCARA',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.divider),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.textSecondary.withOpacity(0.6),
                  size: 56,
                ),
                const SizedBox(height: 12),
                Text(
                  'Camera preview placeholder',
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PoseLibraryButton(onTap: _openPoseLibrary),
          _CaptureButton(onTap: _onCapture),
          _CameraSwitchButton(
            isFrontCamera: _isFrontCamera,
            onTap: _toggleCamera,
          ),
        ],
      ),
    );
  }
}

class _PoseLibraryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PoseLibraryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: const Icon(
              Icons.grid_view_outlined,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Poses',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CaptureButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 74,
        height: 74,
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.gold, width: 3),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.gold,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _CameraSwitchButton extends StatelessWidget {
  final bool isFrontCamera;
  final VoidCallback onTap;

  const _CameraSwitchButton({
    required this.isFrontCamera,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: const Icon(
              Icons.cameraswitch_outlined,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isFrontCamera ? 'Front' : 'Back',
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
