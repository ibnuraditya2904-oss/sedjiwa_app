import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';
import '../../presentation/pages/dass_result_page.dart';
import '../services/cbf_recommendation_service.dart';

class RecommendationRepository {
  List<Activity> getRecommendations(DassResultData data) {
    return CbfRecommendationService.generate(data);
  }
}

/// 🔥 INI YANG LO KURANGIN (PENTING BANGET)
final recommendationRepositoryProvider =
    Provider<RecommendationRepository>((ref) {
  return RecommendationRepository();
});
