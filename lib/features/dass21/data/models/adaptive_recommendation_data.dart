class AdaptiveRecommendationData {
  final String summary;
  final List<String> symptoms;
  final List<String> activities;
  final String dominantAspect;

  const AdaptiveRecommendationData({
    required this.summary,
    required this.symptoms,
    required this.activities,
    required this.dominantAspect,
  });
}
