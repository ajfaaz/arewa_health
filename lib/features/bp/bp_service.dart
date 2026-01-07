import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bp_model.dart';

class BPService {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> saveBP({
    required int systolic,
    required int diastolic,
    required int pulse,
    required String category,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('bp').add({
      'uid': uid, // ✅ REQUIRED
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'category': category,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> bpHistory() {
    return _db
        .collection('bp')
        .where('uid', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<List<BPModel>> fetchLast7DaysBP(String uid) async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Note: This query requires a composite index on 'uid' and 'createdAt'
    final snapshot = await _db
        .collection('bp')
        .where('uid', isEqualTo: uid)
        .where('createdAt', isGreaterThan: Timestamp.fromDate(sevenDaysAgo))
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((d) => BPModel.fromFirestore(d)).toList();
  }

  Future<Map<String, dynamic>?> latestBP(String uid) async {
    final snap = await FirebaseFirestore.instance
        .collection('bp')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return snap.docs.first.data();
  }
}
