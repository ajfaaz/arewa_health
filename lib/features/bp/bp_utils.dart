import '../../models/bp_reading.dart';

bool isCriticalRisk({
  required String bpCategory,
  required bool diabetic,
  required int sleepMinutes,
}) {
  if (bpCategory == "Hypertensive Crisis") return true;
  if (bpCategory.contains("Stage") && diabetic) return true;
  if (sleepMinutes < 300 && bpCategory != "Normal") return true;
  return false;
}

String classifyBP(int systolic, int diastolic) {
  final reading = BPReading(
    systolic: systolic,
    diastolic: diastolic,
    recordedAt: DateTime.now(),
  );
  return reading.category;
}

class BpUtils {
  static bool isHighBP(int systolic, int diastolic) {
    final category = classifyBP(systolic, diastolic);
    return category == "Hypertensive Crisis" || category.startsWith("High BP");
  }

  static String bpStatus(int s, int d) {
    final category = classifyBP(s, d);
    if (category == "Normal") return "normal";
    if (category == "Elevated") return "elevated";
    return "high";
  }
}
