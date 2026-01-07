import 'insight_engine.dart';
import 'insight_model.dart';

class InsightService {
  static List<HealthInsight> generateInsights({
    int? systolic,
    int? diastolic,
    double? sleepHours,
    int? carbs,
  }) {
    List<HealthInsight> insights = [];

    if (systolic != null && diastolic != null) {
      final bp = InsightEngine.bpInsight(systolic, diastolic);
      if (bp != null) insights.add(bp);
    }

    if (sleepHours != null) {
      insights.add(InsightEngine.sleepInsight(sleepHours));
    }

    if (carbs != null) {
      insights.add(InsightEngine.carbInsight(carbs));
    }

    return insights;
  }
}
