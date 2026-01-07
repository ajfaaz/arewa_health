class HealthInsight {
  final String title;
  final String message;
  final String type; // info | warning | success

  HealthInsight({
    required this.title,
    required this.message,
    required this.type,
  });
}
