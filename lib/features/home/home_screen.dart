import '../../core/insights/insight_engine.dart';
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
import '../../utils/bp_utils.dart';
import '../../models/bp_category.dart';
import '../bp/bp_history.dart';
import '../ai_insights/insight_card.dart';
import '../ai_insights/insight_service.dart';
import '../ai_insights/health_score_engine.dart';
import '../ai_insights/health_score_card.dart';
import '../insights/insight_service.dart' as legacy;
import '../insights/alert_engine.dart';
import '../meal/meal_screen.dart';
import '../../models/bp_reading.dart';
import '../../models/sleep_session.dart';
import '../../widgets/health_insight_card.dart';
import '../../models/health_trend.dart';
import '../../widgets/health_trend_card.dart';
import '../../widgets/health_recommendation_card.dart';

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
          // Generate and show health insights (sleep + bp + profile)
          if (uid != null)
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('profiles')
                  .doc(uid)
                  .snapshots(),
              builder: (context, profileSnap) {
                if (!profileSnap.hasData) return const SizedBox.shrink();

                final profileData =
                    profileSnap.data!.data() as Map<String, dynamic>?;
                final bool isDiabetic = profileData?['diabetic'] ?? false;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('bp')
                      .where('uid', isEqualTo: uid)
                      .orderBy('createdAt', descending: true)
                      .limit(20)
                      .snapshots(),
                  builder: (context, bpSnap) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: context.read<SleepService>().sleepHistory(),
                      builder: (context, sleepSnap) {
                        if (!bpSnap.hasData || !sleepSnap.hasData) {
                          return const SizedBox.shrink();
                        }

                        final bpHistory = bpSnap.data!.docs.map((d) {
                          final data = d.data() as Map<String, dynamic>;
                          return BPReading(
                            systolic: data['systolic'] as int,
                            diastolic: data['diastolic'] as int,
                            recordedAt: (data['createdAt'] as Timestamp).toDate(),
                          );
                        }).toList();

                        final sleepHistory = sleepSnap.data!.docs.map((d) {
                          final data = d.data() as Map<String, dynamic>;
                          return SleepSession(
                            startTime: (data['startTime'] as Timestamp).toDate(),
                            endTime: data['endTime'] != null
                                ? (data['endTime'] as Timestamp).toDate()
                                : null,
                          );
                        }).toList();

                        final avgSleepHours = sleepHistory.isNotEmpty
                            ? sleepHistory.map((s) => s.hours).reduce((a, b) => a + b) / sleepHistory.length
                            : 7.0;

                        final latestBp = bpHistory.isNotEmpty ? bpHistory.first : null;

                        final healthScore = InsightEngine.calculateScore(
                          avgSleepHours: avgSleepHours,
                          systolic: latestBp?.systolic ?? 120,
                          diastolic: latestBp?.diastolic ?? 80,
                          diabetic: isDiabetic,
                        );

                        final insights = InsightEngine.generate(
                          sleep: sleepHistory,
                          bp: bpHistory,
                          isDiabetic: isDiabetic,
                        );

                        // Trend Analysis
                        final now = DateTime.now();
                        final sevenDaysAgo = now.subtract(const Duration(days: 7));
                        final fourteenDaysAgo = now.subtract(const Duration(days: 14));

                        final thisWeek = sleepHistory.where((s) => s.startTime.isAfter(sevenDaysAgo));
                        final lastWeek = sleepHistory.where((s) => s.startTime.isAfter(fourteenDaysAgo) && s.startTime.isBefore(sevenDaysAgo));

                        HealthTrend? sleepTrend;
                        if (thisWeek.isNotEmpty && lastWeek.isNotEmpty) {
                          final currentAvg = thisWeek.map((s) => s.hours).reduce((a, b) => a + b) / thisWeek.length;
                          final prevAvg = lastWeek.map((s) => s.hours).reduce((a, b) => a + b) / lastWeek.length;
                          
                          sleepTrend = InsightEngine.analyzeTrend(
                            previous: prevAvg,
                            current: currentAvg,
                            metric: "Sleep quality",
                          );
                        }

                        final recommendations = InsightEngine.generateRecommendations(
                          healthScore: healthScore.score,
                          diabetic: isDiabetic,
                          highBP: (latestBp?.systolic ?? 120) >= 130 || (latestBp?.diastolic ?? 80) >= 81,
                        );

                        if (insights.isEmpty && recommendations.isEmpty) return const SizedBox.shrink();

                        return Column(
                          children: [
                            HealthScoreCard(healthScore: healthScore),
                            const SizedBox(height: 12),
                            if (sleepTrend != null) ...[
                              HealthTrendCard(trend: sleepTrend),
                              const SizedBox(height: 12),
                            ],
                            ...recommendations.map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: HealthRecommendationCard(rec: r),
                            )),
                            ...insights.map((i) => HealthInsightCard(insight: i)).toList(),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          if (uid != null)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.insights, color: Colors.deepPurple),
                  title: Text("Sleep Insight", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    "Sleeping less than 6 hours may increase blood pressure.",
                  ),
                ),
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
                      
                      final category = classifyBP(sys, dia);
                      bpTitle = "$sys/$dia mmHg";

                      if (category != BpCategory.normal) {
                        highBP = true;
                      }

                      // Critical BP Warning (Day 4)
                      if (category == BpCategory.crisis) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && ModalRoute.of(context)?.isCurrent == true) {
                            _showCriticalBPDialog(context);
                          }
                        });
                      }
                    }

                    final bpColorVal = highBP ? Colors.red.shade100 : Colors.green.shade100;

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
                          color: bpColorVal,
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

  void _showCriticalBPDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Medical Alert", style: TextStyle(color: Colors.red)),
        content: const Text(
          "Your blood pressure is dangerously high.\n"
          "Please seek medical care immediately."
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("I Understand")),
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