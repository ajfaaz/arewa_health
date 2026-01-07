import 'package:cloud_firestore/cloud_firestore.dart';

class InsightService {
  final _db = FirebaseFirestore.instance;

  // 🔹 Latest BP
  Future<Map<String, int>?> fetchLatestBP(String uid) async {
    final snap = await _db
        .collection('bp')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    final data = snap.docs.first.data();
    return {
      'systolic': data['systolic'],
      'diastolic': data['diastolic'],
    };
  }

  // 🔹 Average Sleep (Last 7 records)
  Future<double> fetchAverageSleep(String uid) async {
    final snap = await _db
        .collection('sleep')
        .where('uid', isEqualTo: uid)
        .orderBy('startTime', descending: true)
        .limit(7)
        .get();

    if (snap.docs.isEmpty) return 0;

    double totalHours = 0;

    for (var doc in snap.docs) {
      final minutes = (doc['durationMinutes'] ?? 0) as int;
      totalHours += minutes / 60.0;
    }

    return totalHours / snap.docs.length;
  }
}
