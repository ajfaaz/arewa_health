import 'package:cloud_firestore/cloud_firestore.dart';
import 'weekly_health_model.dart';

class WeeklyHealthService {
  final _db = FirebaseFirestore.instance;

  Stream<List<WeeklyHealthData>> last7Days(String uid) {
    final since = DateTime.now().subtract(const Duration(days: 7));

    return _db
        .collection('health_scores')
        .where('uid', isEqualTo: uid)
        .where('date', isGreaterThan: Timestamp.fromDate(since))
        .orderBy('date')
        .snapshots()
        .map((snap) {
      return snap.docs.map((d) {
        final data = d.data();
        return WeeklyHealthData(
          date: (data['date'] as Timestamp).toDate(),
          score: data['score'],
          systolic: data['systolic'],
          sleepHours: (data['sleepHours'] as num).toDouble(),
        );
      }).toList();
    });
  }
}
