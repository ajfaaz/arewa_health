int calculateHealthScore({
  required double avgSleep,
  required int systolic,
  required int diastolic,
}) {
  int score = 100;

  // 💤 Sleep impact
  if (avgSleep < 5) {
    score -= 30;
  } else if (avgSleep < 6.5) {
    score -= 15;
  }

  // ❤️ BP impact
  if (systolic >= 140 || diastolic >= 90) {
    score -= 30;
  } else if (systolic >= 130 || diastolic >= 80) {
    score -= 15;
  }

  return score.clamp(0, 100);
}
