/// Represents a single pose in the pose library.
///
/// For now, [imageAsset] points to a placeholder path — real pose
/// photography will be added later. If the asset doesn't exist yet,
/// the UI falls back to a generated placeholder automatically
/// (see PosePlaceholderImage).
class PoseModel {
  final String id;
  final int poseNumber;
  final String name;
  final String category;
  final String description;
  final String imageAsset;
  bool isFavorite;

  PoseModel({
    required this.id,
    required this.poseNumber,
    required this.name,
    required this.category,
    required this.description,
    required this.imageAsset,
    this.isFavorite = false,
  });
}
