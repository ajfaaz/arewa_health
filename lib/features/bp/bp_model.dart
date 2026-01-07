import 'package:cloud_firestore/cloud_firestore.dart';

class BPModel {
  final String id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final String category;
  final DateTime createdAt;

  BPModel({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.category,
    required this.createdAt,
  });

  factory BPModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BPModel(
      id: doc.id,
      systolic: data['systolic'] ?? 0,
      diastolic: data['diastolic'] ?? 0,
      pulse: data['pulse'] ?? 0,
      category: data['category'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}