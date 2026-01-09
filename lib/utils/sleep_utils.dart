enum SleepQuality { poor, fair, good }

SleepQuality sleepQualityFromSeconds(int seconds) {
  final hours = seconds / 3600;

  if (hours < 6) return SleepQuality.poor;
  if (hours < 7) return SleepQuality.fair;
  return SleepQuality.good;
}

String sleepQualityLabel(SleepQuality q) {
  switch (q) {
    case SleepQuality.poor: return "Poor sleep";
    case SleepQuality.fair: return "Fair sleep";
    case SleepQuality.good: return "Good sleep";
  }
}
