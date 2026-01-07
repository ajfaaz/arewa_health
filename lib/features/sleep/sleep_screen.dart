import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart';
import '../profile/profile_service.dart';
import 'sleep_service.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final SleepService _sleepService = SleepService();
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _loadLang();
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

  bool sleeping = false;
  bool loading = false;
  String? activeSleepId;
  DateTime? startTime;

  Future<void> startSleep() async {
    setState(() => loading = true);

    final DocumentSnapshot result =
    await _sleepService.startSleep();


    setState(() {
      activeSleepId = result.id;
      startTime = (result['startTime'] as Timestamp).toDate();
      sleeping = true;
      loading = false;
    });
  }

  Future<void> stopSleep() async {
    if (activeSleepId == null || startTime == null) return;

    setState(() => loading = true);

    await _sleepService.stopSleep(activeSleepId!, Timestamp.fromDate(startTime!));

    setState(() {
      sleeping = false;
      activeSleepId = null;
      startTime = null;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t("sleep", lang))),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: activeSleepId == null
                ? startSleep
                : () async {
                    await _sleepService.stopSleep(
                        activeSleepId!, Timestamp.fromDate(startTime!));

                    setState(() {
                      activeSleepId = null;
                      startTime = null;
                    });
                  },
            child: Text(activeSleepId == null
                ? AppStrings.t("start_sleep", lang)
                : AppStrings.t("stop_sleep", lang)),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _sleepService.sleepHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No sleep records yet"));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, index) {
                    final data = docs[index];
                    final start = (data['startTime'] as Timestamp).toDate();
                    final duration = data['durationMinutes'];

                    return ListTile(
                      title: Text("Start: $start"),
                      subtitle: Text(
                        duration == null
                            ? "Sleeping..."
                            : "Duration: $duration minutes",
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
