class SleepSession {
  final DateTime startTime;
  final DateTime? endTime;

  SleepSession({
    required this.startTime,
    this.endTime,
  });

  Duration get duration {
    if (endTime == null) return Duration.zero;
    return endTime!.difference(startTime);
  }

  double get hours => duration.inMinutes / 60;

  String get quality {
    if (hours >= 7) return "Good";
    if (hours >= 6) return "Fair";
    return "Poor";
  }
}

