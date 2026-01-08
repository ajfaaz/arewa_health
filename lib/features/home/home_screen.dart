import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/language_provider.dart';
import '../profile/profile_service.dart';
import '../sleep/sleep_service.dart';
import '../sleep/sleep_status_card.dart';
import '../sleep/sleep_screen.dart';
import '../sleep/sleep_history_screen.dart';
import '../bp/bp_screen.dart';
import '../bp/bp_utils.dart';
import '../bp/bp_history.dart';
import '../ai_insights/insight_card.dart';
import '../ai_insights/insight_service.dart';
import '../ai_insights/health_score_engine.dart';
import '../ai_insights/health_score_card.dart';
import '../ai_insights/weekly_health_service.dart';
import '../ai_insights/weekly_health_chart.dart';
import '../ai_insights/weekly_health_model.dart';
import '../insights/insight_service.dart' as legacy;
import '../insights/alert_engine.dart';
import '../meal/meal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    _loadLang();
    // Initialize SleepService to load active sleep status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SleepService>().init();
    });
  }

  Future<void> _loadLang() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final l = await ProfileService().getUserLanguage(user.uid);
      if (mounted) {
        context.read<LanguageProvider>().setLanguage(l);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final lang = context.watch<LanguageProvider>().lang;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t("home", lang)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (uid != null)
            FutureBuilder<Map<String, int>?>(
              future: legacy.InsightService().fetchLatestBP(uid),
              builder: (context, bpSnap) {
                if (!bpSnap.hasData) return const SizedBox.shrink();

                return FutureBuilder<double>(
                  future: legacy.InsightService().fetchAverageSleep(uid),
                  builder: (context, sleepSnap) {
                    if (!sleepSnap.hasData) return const SizedBox.shrink();

                    final insights = InsightService.generateInsights(
                      systolic: bpSnap.data!['systolic'],
                      diastolic: bpSnap.data!['diastolic'],
                      sleepHours: sleepSnap.data,
                    );

                    final healthScore = HealthScoreEngine.calculate(
                      systolic: bpSnap.data!['systolic'],
                      diastolic: bpSnap.data!['diastolic'],
                      sleepHours: sleepSnap.data,
                    );

                    final alert = generateAlert(
                      avgSleep: sleepSnap.data!,
                      systolic: bpSnap.data!['systolic']!,
                      diastolic: bpSnap.data!['diastolic']!,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          ...insights.map((i) => InsightCard(insight: i)),
                          const SizedBox(height: 12),
                          HealthScoreCard(healthScore: healthScore),
                          if (alert != null)
                            Card(
                              color: Colors.red.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  alert,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          // Active Sleep Status Card
          if (uid != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Consumer<SleepService>(
                builder: (context, sleepService, child) => SleepStatusCard(
                  isSleeping: sleepService.isSleeping,
                  startTime: sleepService.startTime,
                  lastSleepDuration: sleepService.lastSleepDuration,
                  onStart: sleepService.startSleep,
                  onStop: sleepService.stopSleep,
                ),
              ),
            ),
          if (uid != null)
            SizedBox(
              height: 250,
              child: StreamBuilder<List<WeeklyHealthData>>(
                stream: WeeklyHealthService().last7Days(uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red)),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No chart data available"));
                  }
                  return WeeklyHealthChart(data: snapshot.data!);
                },
              ),
            ),
          if (uid != null)
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('profiles')
                  .doc(uid)
                  .snapshots(),
              builder: (context, profileSnap) {
                final profileData =
                    profileSnap.data?.data() as Map<String, dynamic>?;
                final bool diabetic = profileData?['diabetic'] ?? false;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('bp')
                      .where('uid', isEqualTo: uid)
                      .orderBy('createdAt', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, bpSnap) {
                    String bpTitle = AppStrings.t("bp", lang);
                    bool highBP = false;

                    if (bpSnap.hasData && bpSnap.data!.docs.isNotEmpty) {
                      final data = bpSnap.data!.docs.first;
                      final sys = data['systolic'];
                      final dia = data['diastolic'];
                      bpTitle = "$sys/$dia mmHg";

                      final category = classifyBP(sys, dia);
                      if (category.contains("High") ||
                          category == "Hypertensive Crisis") {
                        highBP = true;
                      }
                    }

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _HomeCard(
                          title: AppStrings.t("sleep", lang),
                          icon: Icons.bedtime,
                          color: Colors.indigo.shade100,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SleepScreen()),
                          ),
                        ),
                        _HomeCard(
                          title: "Sleep History",
                          icon: Icons.history,
                          color: Colors.blueGrey.shade100,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SleepHistoryScreen()),
                          ),
                        ),
                        _HomeCard(
                          title: bpTitle,
                          icon: Icons.favorite,
                          color: Colors.red.shade100,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const BPScreen()),
                          ),
                        ),
                        _HomeCard(
                          title: "BP History",
                          icon: Icons.show_chart,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const BpHistoryScreen()),
                            );
                          },
                        ),
                        _HomeCard(
                          title: AppStrings.t("meal", lang),
                          icon: Icons.restaurant,
                          color: Colors.green.shade100,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MealScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _HomeCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.black87),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}