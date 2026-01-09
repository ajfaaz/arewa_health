enum RecommendationType { sleep, bp, diet, exercise }

class HealthRecommendation {
  final RecommendationType type;
  final String message;

  HealthRecommendation({
    required this.type,
    required this.message,
  });
}
