enum InsightSeverity { normal, warning, danger }

class HealthInsight {
  final String title;
  final String message;
  final InsightSeverity severity;
  final String source; // sleep, bp, diet

  HealthInsight({
    required this.title,
    required this.message,
    required this.severity,
    required this.source,
  });
}
