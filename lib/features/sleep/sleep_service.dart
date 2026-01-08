import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SleepService extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;
  CollectionReference get _sleepRef => _db.collection('sleep');

  String? activeSleepId;
  DateTime? startTime;
  Duration? lastSleepDuration;

  bool get isSleeping => activeSleepId != null;

  Future<void> init() async {
    try {
      await _loadActiveSleep();
      await _loadLastSleep();
    } catch (e) {
      debugPrint("SleepService init error: $e");
    }
  }

  Future<void> _loadActiveSleep() async {
    final doc = await getActiveSleep();
    if (doc != null) {
      activeSleepId = doc.id;
      startTime = (doc['startTime'] as Timestamp).toDate();
      notifyListeners();
    }
  }

  Future<void> _loadLastSleep() async {
    // Fetch recent records to find the last completed sleep.
    // This avoids Firestore index errors with inequality filters + sorting.
    final query = await _sleepRef
        .where('uid', isEqualTo: _uid)
        .orderBy('startTime', descending: true)
        .limit(10)
        .get();

    for (var doc in query.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['durationMinutes'] != null) {
        lastSleepDuration = Duration(minutes: data['durationMinutes'] as int);
        notifyListeners();
        return;
      }
    }
  }

  Future<void> startSleep() async {
    final now = DateTime.now();
    final docRef = await _sleepRef.add({
      'uid': _uid, // MUST add this for the query to work
      'startTime': Timestamp.fromDate(now),
      'endTime': null,
      'durationMinutes': null,
    });

    activeSleepId = docRef.id;
    startTime = now;
    notifyListeners();
  }

  Future<void> stopSleep() async {
    if (activeSleepId == null || startTime == null) return;

    final docRef = _sleepRef.doc(activeSleepId);
    final endTime = DateTime.now();
    final durationMinutes = endTime.difference(startTime!).inMinutes;

    await docRef.update({
      'endTime': Timestamp.fromDate(endTime),
      'durationMinutes': durationMinutes,
    });

    lastSleepDuration = Duration(minutes: durationMinutes);
    activeSleepId = null;
    startTime = null;
    notifyListeners();
  }

  Future<DocumentSnapshot?> getActiveSleep() async {
    final query = await _sleepRef
        .where('uid', isEqualTo: _uid)
        .where('endTime', isNull: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return query.docs.first;
  }

  Stream<QuerySnapshot> sleepHistory() {
    return _sleepRef
        .where('uid', isEqualTo: _uid)
        .orderBy('startTime', descending: true) // Matches the save logic
        .snapshots();
  }
}