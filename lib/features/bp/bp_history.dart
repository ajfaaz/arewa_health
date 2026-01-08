import 'package:arewa_health/features/bp/bp_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';
import 'bp_line_chart.dart';
import 'bp_service.dart';

class BpHistoryScreen extends StatefulWidget {
  const BpHistoryScreen({super.key});

  @override
  State<BpHistoryScreen> createState() => _BpHistoryScreenState();
}

class _BpHistoryScreenState extends State<BpHistoryScreen> {
  final BPService bpService = BPService();

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Blood Pressure History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: bpService.bpHistory(),
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

          // Render chart from documents
          return BPLineChart(docs);
        },
      ),
    );
  }
}
