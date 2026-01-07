import 'health_score_model.dart';

class HealthScoreEngine {
  static HealthScore calculate({
    int? systolic,
    int? diastolic,
    double? sleepHours,
    int? carbs,
    bool highSalt = false,
  }) {
    int score = 0;
    List<String> feedback = [];

    // ❤️ BP (40)
    if (systolic != null && diastolic != null) {
      if (systolic < 120 && diastolic < 80) {
        score += 40;
        feedback.add("Blood pressure is excellent");
      } else if (systolic < 140) {
        score += 25;
        feedback.add("Blood pressure is slightly high");
      } else {
        score += 10;
        feedback.add("High blood pressure detected");
      }
    }

    // 😴 Sleep (30)
    if (sleepHours != null) {
      if (sleepHours >= 7) {
        score += 30;
        feedback.add("Good sleep duration");
      } else if (sleepHours >= 6) {
        score += 20;
        feedback.add("Sleep could be better");
      } else {
        score += 10;
        feedback.add("Poor sleep affects BP");
      }
    }

    // 🍲 Meals (30)
    if (carbs != null) {
      if (carbs <= 45 && !highSalt) {
        score += 30;
        feedback.add("Healthy meal choices");
      } else if (carbs <= 60) {
        score += 20;
        feedback.add("Moderate carb intake");
      } else {
        score += 10;
        feedback.add("High carb or salty meals");
      }
    }

    return HealthScore(
      score: score.clamp(0, 100),
      message: feedback.join(". "),
    );
  }
}

