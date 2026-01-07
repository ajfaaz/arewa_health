import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SleepService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;
  CollectionReference get _sleepRef => _db.collection('sleep');

  Future<DocumentSnapshot> startSleep() async {
    final ref = await _sleepRef.add({
      'uid': _uid, // MUST add this for the query to work
      'startTime': Timestamp.now(), // We will use 'startTime' everywhere
      'endTime': null,
      'durationMinutes': null,
    });

    return ref.get();
  }

  Future<void> stopSleep(String docId, Timestamp startTime) async {
    final endTime = Timestamp.now();
    final duration = endTime.toDate().difference(startTime.toDate()).inMinutes;

    await _sleepRef.doc(docId).update({
      'endTime': endTime,
      'durationMinutes': duration,
    });
  }

  Stream<QuerySnapshot> sleepHistory() {
    return _sleepRef
        .where('uid', isEqualTo: _uid)
        .orderBy('startTime', descending: true) // Matches the save logic
        .snapshots();
  }
}