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
  if (systolic > 180 || diastolic > 120) {
    return "Hypertensive Crisis";
  }

  if (systolic >= 140 || diastolic >= 90) {
    return "High BP (Stage 2)";
  }

  if ((systolic >= 130 && systolic <= 139) ||
      (diastolic >= 80 && diastolic <= 89)) {
    return "High BP (Stage 1)";
  }

  if (systolic >= 120 && systolic <= 129 && diastolic < 80) {
    return "Elevated";
  }

  return "Normal";
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
