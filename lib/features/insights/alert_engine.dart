String? generateAlert({
  required double avgSleep,
  required int systolic,
  required int diastolic,
}) {
  if (avgSleep < 5 && systolic >= 140) {
    return "🚨 Poor sleep is contributing to very high blood pressure.";
  }

  if (avgSleep < 6) {
    return "⚠️ Try to sleep earlier. Low sleep increases BP risk.";
  }

  if (systolic >= 130 || diastolic >= 80) {
    return "⚠️ Monitor your blood pressure closely today.";
  }

  return null;
}
