import 'insight_model.dart';
import '../../utils/bp_utils.dart';
import '../../models/bp_category.dart';

HealthInsight buildHealthInsight({
  required int systolic,
  required int diastolic,
  required double avgSleep,
}) {
  final bpCategory = classifyBP(systolic, diastolic);

  if (avgSleep < 6 && (bpCategory == BpCategory.stage1 || bpCategory == BpCategory.stage2 || bpCategory == BpCategory.crisis)) {
    return HealthInsight(
      title: "High BP Risk",
      message:
          "Your blood pressure is high and sleep duration is low. Poor sleep may be increasing your BP.",
      type: "warning",
    );
  }

  if (avgSleep >= 7 && bpCategory == BpCategory.normal) {
    return HealthInsight(
      title: "Healthy Pattern",
      message:
          "Your sleep habits are supporting a healthy blood pressure level.",
      type: "success",
    );
  }

  return HealthInsight(
    title: "Health Tip",
    message:
        "Track your sleep and blood pressure consistently to unlock deeper insights.",
    type: "info",
  );
}
