import 'insight_model.dart';
import '../bp/bp_utils.dart';

HealthInsight buildHealthInsight({
  required int systolic,
  required int diastolic,
  required double avgSleep,
}) {
  final bpStatus = classifyBP(systolic, diastolic);

  if (avgSleep < 6 && bpStatus.contains("High")) {
    return HealthInsight(
      title: "High BP Risk",
      message:
          "Your blood pressure is high and sleep duration is low. Poor sleep may be increasing your BP.",
      type: "warning",
    );
  }

  if (avgSleep >= 7 && bpStatus == "Normal") {
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
