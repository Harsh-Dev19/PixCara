import '../models/pose_model.dart';

/// Categories shown as filter chips in the Pose Library.
const List<String> poseCategories = [
  'Solo',
  'Sitting',
  'Standing',
  'Casual',
  'Formal',
  'Full Body',
  'Mirror',
  'Couple',
];

/// Temporary in-memory pose list, used until real pose data
/// (from backend or bundled assets) is wired up in a later stage.
List<PoseModel> dummyPoses = List.generate(18, (index) {
  final category = poseCategories[index % poseCategories.length];
  return PoseModel(
    id: 'pose_$index',
    poseNumber: index + 1,
    name: 'Pose ${index + 1}',
    category: category,
    description:
        'A flattering $category pose. Align your shoulders and hips '
        'with the guide, keep your posture relaxed, and follow the '
        'outline shown on screen before you capture.',
    imageAsset: 'assets/poses/pose_$index.jpg',
  );
});
