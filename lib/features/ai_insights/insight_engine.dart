import 'insight_model.dart';
import '../../utils/bp_utils.dart';
import '../../models/bp_category.dart';

class InsightEngine {
  // ❤️ BP INSIGHTS
  static HealthInsight? bpInsight(int systolic, int diastolic) {
    final category = classifyBP(systolic, diastolic);
    
    if (category == BpCategory.stage2 || category == BpCategory.crisis) {
      return HealthInsight(
        title: "High Blood Pressure",
        message: "Reduce salt intake and rest more today.",
        type: InsightType.warning,
      );
    }
    if (category == BpCategory.normal) {
      return HealthInsight(
        title: "BP Normal",
        message: "Great job! Keep your healthy habits.",
        type: InsightType.success,
      );
    }
    return null;
  }

  // 😴 SLEEP INSIGHTS
  static HealthInsight sleepInsight(double hours) {
    if (hours < 6) {
      return HealthInsight(
        title: "Poor Sleep",
        message: "Less than 6 hours sleep increases BP risk.",
        type: InsightType.warning,
      );
    }

    return HealthInsight(
      title: "Good Sleep",
      message: "Your sleep duration supports good health.",
      type: InsightType.success,
    );
  }

  // 🍲 MEAL + DIABETES
  static HealthInsight carbInsight(int carbs) {
    if (carbs > 60) {
      return HealthInsight(
        title: "High Carbs",
        message: "High carbs may spike blood sugar.",
        type: InsightType.warning,
      );
    }

    return HealthInsight(
      title: "Balanced Meal",
      message: "Your meal is diabetes-friendly.",
      type: InsightType.success,
    );
  }
}
