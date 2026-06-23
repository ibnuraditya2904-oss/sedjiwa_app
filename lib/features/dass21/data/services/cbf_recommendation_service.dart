import '../models/activity_model.dart';
import '../datasources/dummy_activity_data.dart';
import '../../presentation/pages/dass_result_page.dart';

class CbfRecommendationService {
  static List<Activity> generate(DassResultData data) {
    // 🔥 STEP 1: ambil label terburuk (overall)
    final label = data.overallLabel;

    // 🔥 STEP 2: mapping label → tag level
    final levelTag = _mapLabelToLevel(label);

    // 🔥 STEP 3: tentukan aspek dominan
    final dominantAspect = _getDominantAspect(data);

    // 🔥 STEP 4: filter activity (CBF core)
    final filtered = DummyActivityData.activities.where((activity) {
      return activity.tags.contains(levelTag) &&
          activity.tags.contains(dominantAspect);
    }).toList();

    return filtered;
  }

  // 🔥 mapping label → tag
  static String _mapLabelToLevel(String label) {
    switch (label) {
      case "Resiko Rendah":
        return "ringan";
      case "Resiko Ringan":
        return "ringan";
      case "Resiko Sedang":
        return "sedang";
      case "Resiko Tinggi":
        return "berat";
      case "Resiko Sangat Tinggi":
        return "berat";
      default:
        return "ringan";
    }
  }

  // 🔥 ambil aspek paling dominan
  static String _getDominantAspect(DassResultData data) {
    final scores = {
      "depression": data.depressionScore,
      "anxiety": data.anxietyScore,
      "stress": data.stressScore,
    };

    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
