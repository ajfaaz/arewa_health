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
  if (systolic <= 120 && diastolic <= 80) {
    return "Normal";
  } else if (systolic < 130 && diastolic <= 80) {
    return "Elevated";
  } else if (systolic < 140 || diastolic < 90) {
    return "High (Stage 1)";
  } else {
    return "High (Stage 2)";
  }
}

class BpUtils {
  static bool isHighBP(int systolic, int diastolic) {
    return systolic >= 130 || diastolic > 80;
  }

  static String bpStatus(int s, int d) {
    if (s >= 130 || d > 80) return "high";
    if (s > 120 && d <= 80) return "elevated";
    return "normal";
  }
}
