import 'package:arewa_health/features/ai_insights/health_score_model.dart';
import 'package:arewa_health/models/health_trend.dart';

import '../../models/health_insight.dart';
import '../../models/sleep_session.dart';
import '../../models/bp_reading.dart';
import '../../models/health_recommendation.dart';

class InsightEngine {
  static List<HealthInsight> generate({
    required List<SleepSession> sleep,
    required List<BPReading> bp,
    required bool isDiabetic,
  }) {
    final insights = <HealthInsight>[];

    // 💤 Sleep analysis
    if (sleep.isNotEmpty) {
      final avgSleep =
          sleep.map((s) => s.hours).reduce((a, b) => a + b) / sleep.length;

      if (avgSleep < 6) {
        insights.add(
          HealthInsight(
            title: "Poor Sleep Pattern",
            message:
                "You are sleeping less than 6 hours on average. This increases blood pressure and diabetes risk.",
            severity: InsightSeverity.warning,
            source: "sleep",
          ),
        );
      }
    }

    // 🩺 Blood Pressure analysis
    if (bp.isNotEmpty) {
      final highReadings =
          bp.where((r) => r.isHighRisk).length;

      if (highReadings >= 3) {
        insights.add(
          HealthInsight(
            title: "High Blood Pressure Risk",
            message:
                "Multiple high BP readings detected. Please monitor closely and reduce salt intake.",
            severity: InsightSeverity.danger,
            source: "bp",
          ),
        );
      }
    }

    // 🍽 Diabetes cross-check
    if (isDiabetic) {
      insights.add(
        HealthInsight(
          title: "Diabetes Care Reminder",
          message:
              "Maintain consistent meals and avoid late-night eating to keep blood sugar stable.",
          severity: InsightSeverity.normal,
          source: "diet",
        ),
      );
    }

    return insights;
  }

  static HealthScore calculateScore({
    required double avgSleepHours,
    required int systolic,
    required int diastolic,
    required bool diabetic,
  }) {
    int score = 100;

    // Sleep impact
    if (avgSleepHours < 6) score -= 25;
    else if (avgSleepHours < 7) score -= 10;

    // Blood pressure impact
    if (systolic >= 140 || diastolic >= 90) score -= 30;
    else if (systolic >= 130 || diastolic >= 81) score -= 15;

    // Diabetic risk
    if (diabetic) score -= 10;

    score = score.clamp(0, 100);

    String label;
    String message;

    if (score >= 80) {
      label = "Excellent";
      message = "You are doing great! Keep it up.";
    } else if (score >= 60) {
      label = "Moderate";
      message = "Some improvements are needed.";
    } else {
      label = "High Risk";
      message = "Please take care and consult a doctor.";
    }

    return HealthScore(
      score: score,
      label: label,
      message: message,
    );
  }

  static HealthTrend analyzeTrend({
    required double previous,
    required double current,
    required String metric,
  }) {
    if (current > previous) {
      return HealthTrend(
        direction: TrendDirection.improving,
        message: "$metric is improving 📈",
      );
    } else if (current < previous) {
      return HealthTrend(
        direction: TrendDirection.worsening,
        message: "$metric is worsening 📉",
      );
    } else {
      return HealthTrend(
        direction: TrendDirection.stable,
        message: "$metric is stable ➖",
      );
    }
  }

  static List<HealthRecommendation> generateRecommendations({
    required int healthScore,
    required bool diabetic,
    required bool highBP,
  }) {
    final List<HealthRecommendation> recs = [];

    if (healthScore < 50) {
      recs.add(HealthRecommendation(
        type: RecommendationType.sleep,
        message: "Try sleeping before 10pm for better recovery",
      ));
    }

    if (highBP) {
      recs.add(HealthRecommendation(
        type: RecommendationType.diet,
        message: "Reduce salt intake and avoid fried foods this week",
      ));
    }

    if (diabetic) {
      recs.add(HealthRecommendation(
        type: RecommendationType.exercise,
        message: "Walk at least 30 minutes daily to improve sugar control",
      ));
    }

    return recs;
  }
}
