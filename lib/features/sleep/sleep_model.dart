class SleepRecord {
  final DateTime startTime;
  final DateTime? endTime;
  final int? durationMinutes;

  SleepRecord({
    required this.startTime,
    this.endTime,
    this.durationMinutes,
  });

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'durationMinutes': durationMinutes,
    };
  }
}
