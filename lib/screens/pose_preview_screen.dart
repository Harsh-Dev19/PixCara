import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _openSourceUrl() async {
    final url = widget.pose.sourceUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
                  child: PosePlaceholderImage(
                    imageAsset: pose.imageAsset,
                    imageUrl: pose.imageUrl,
                  ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pose.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (pose.isRemote) ...[
                            const SizedBox(height: 10),
                            _buildPhotoCredit(),
                          ],
                        ],
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

  /// Photographer credit + link back to the original Pexels photo page.
  /// Only shown for poses sourced from Pexels.
  Widget _buildPhotoCredit() {
    final photographer = widget.pose.photographer;
    final hasLink = widget.pose.sourceUrl != null && widget.pose.sourceUrl!.isNotEmpty;

    return GestureDetector(
      onTap: hasLink ? _openSourceUrl : null,
      child: Row(
        children: [
          const Icon(Icons.camera_alt_outlined,
              size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              photographer == null || photographer.isEmpty
                  ? 'Photo via Pexels'
                  : 'Photo by $photographer · Pexels',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
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
