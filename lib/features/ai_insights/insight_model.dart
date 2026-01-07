enum InsightType { warning, tip, success }

class HealthInsight {
  final String title;
  final String message;
  final InsightType type;

  HealthInsight({
    required this.title,
    required this.message,
    required this.type,
  });
}
