enum TrendDirection { improving, stable, worsening }

class HealthTrend {
  final TrendDirection direction;
  final String message;

  HealthTrend({
    required this.direction,
    required this.message,
  });
}
