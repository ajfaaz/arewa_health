import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'sleep_service.dart';

class SleepHistoryScreen extends StatelessWidget {
  const SleepHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sleepService = context.read<SleepService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sleep History"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Using the stream from your SleepService which handles UID and Ordering
        stream: sleepService.sleepHistory(),
        builder: (context, snapshot) {
          // 1. Handle Errors (This is where the Index error will show if not fixed)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Error: ${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // 2. Handle Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          // 3. Handle Empty State
          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.nightlight, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text("No sleep records yet"),
                  Text("Start tracking your sleep tonight 🌙",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // 4. Build the List
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              
              // Mapping fields to match your SleepService.startSleep() keys
              final Timestamp? startTimestamp = data['startTime'] as Timestamp?;
              final DateTime startDate = startTimestamp?.toDate().toLocal() ?? DateTime.now();
              
              // Support both old (minutes) and new (seconds) data
              final int? durationSec = data['durationSeconds'] as int?;
              final int? durationMin = data['durationMinutes'] as int?;
              final int? duration = durationSec != null ? (durationSec / 60).round() : durationMin;

              // Format date: e.g., Jan 1, 10:30 PM
              final String formattedDate = DateFormat('MMM d, h:mm a').format(startDate);

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: duration == null ? Colors.orange.shade100 : Colors.indigo.shade100,
                  child: Icon(
                    duration == null ? Icons.snooze : Icons.bed,
                    color: duration == null ? Colors.orange : Colors.indigo,
                  ),
                ),
                title: Text(
                  formattedDate,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: duration == null
                    ? const Text(
                        "In progress...", 
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)
                      )
                    : Text("$duration minutes of sleep"),
                trailing: const Icon(Icons.chevron_right, size: 16),
                onTap: () {
                  // Optional: Navigate to a detail view or allow editing
                },
              );
            },
          );
        },
      ),
    );
  }
}