import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveProfile(Map<String, dynamic> data) async {
    final uid = _auth.currentUser!.uid;

    await _db.collection('profiles').doc(uid).set(
      data,
      SetOptions(merge: true),
    );
  }

  Future<String> getUserLanguage(String uid) async {
    final doc = await _db
        .collection('profiles')
        .doc(uid)
        .get();

    return doc.data()?['language'] ?? 'en';
  }

  Future<bool> isDiabetic(String uid) async {
    final doc = await _db
        .collection('profiles')
        .doc(uid)
        .get();

    return doc.data()?['diabetic'] ?? false;
  }
}
