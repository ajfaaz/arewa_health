import 'package:arewa_health/features/bp/bp_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';

class BpHistoryScreen extends StatefulWidget {
  const BpHistoryScreen({super.key});

  @override
  State<BpHistoryScreen> createState() => _BpHistoryScreenState();
}

class _BpHistoryScreenState extends State<BpHistoryScreen> {
  Stream<QuerySnapshot>? bpStream;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bpStream = FirebaseFirestore.instance
          .collection('bp')
          .where('uid', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Blood Pressure History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: bpStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text("No BP records yet"),
                  Text("Start tracking your blood pressure today 🩺",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              final sys = d['systolic'] as int;
              final dia = d['diastolic'] as int;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text("Blood Pressure",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "$sys / $dia mmHg",
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      bpStatusBadge(sys, dia),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
