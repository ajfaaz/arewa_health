import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../profile/profile_service.dart';
import 'sleep_service.dart';
import 'sleep_status_card.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _loadLang();
    context.read<SleepService>().init();
  }

  Future<void> _loadLang() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final l = await ProfileService().getUserLanguage(user.uid);
      if (mounted) {
        setState(() => lang = l);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sleepService = context.watch<SleepService>();
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t("sleep", lang))),
      body: StreamBuilder<QuerySnapshot>(
        stream: sleepService.sleepHistory(),
        builder: (context, snapshot) {
          List<QueryDocumentSnapshot> docs = [];

          if (snapshot.hasData) {
            docs = snapshot.data!.docs;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SleepStatusCard(
                  isSleeping: sleepService.isSleeping,
                  startTime: sleepService.startTime,
                  lastSleepDuration: sleepService.lastSleepDuration,
                  onStart: sleepService.startSleep,
                  onStop: sleepService.stopSleep,
                ),
              ),
              Expanded(
                child: docs.isEmpty
                    ? const Center(child: Text("No sleep records yet"))
                    : ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (_, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final start = (data['startTime'] as Timestamp).toDate();
                          final duration = data['durationMinutes'] as int?;

                          if (duration == null) {
                            return ListTile(
                              title: Text("Start: $start"),
                              subtitle: const Text("Sleeping..."),
                            );
                          }

                          final double hoursSlept = duration / 60.0;
                          String sleepMessage;

                          if (hoursSlept < 6) {
                            sleepMessage = "Poor sleep 😴 (less than 6 hours)";
                          } else if (hoursSlept < 7) {
                            sleepMessage = "Fair sleep 🙂";
                          } else {
                            sleepMessage = "Good sleep 🌙";
                          }

                          return ListTile(
                            title: Text("Start: $start"),
                            subtitle: Text(
                                "Duration: $duration minutes\n$sleepMessage"),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
