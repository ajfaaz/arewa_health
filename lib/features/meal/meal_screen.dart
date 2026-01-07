import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/providers/language_provider.dart';
import 'meal_service.dart';
import '../bp/bp_service.dart';
import 'meal_rules.dart';
import '../profile/profile_service.dart';


class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  bool isDiabetic = false;
  bool highBP = false;

  @override
  void initState() {
    super.initState();
    _loadHealthFlags();
  }

  Future<void> _loadHealthFlags() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final diabetic = await ProfileService().isDiabetic(uid);
    final bp = await BPService().latestBP(uid);

    if (mounted) {
      setState(() {
        isDiabetic = diabetic;
        if (bp != null) {
          highBP = (bp['systolic'] > 120) || (bp['diastolic'] > 80);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().lang;
    final days = MealService.getDays(lang);

    return Scaffold(
      appBar: AppBar(title: const Text("Meal Planner")),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (_, i) {
          final meals = MealService.getMealsForDay(lang, days[i]);

          if (meals.isEmpty) {
            return const Center(
              child: Column(
                children: [
                  Icon(Icons.restaurant_menu, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text("No meals planned"),
                ],
              ),
            );
          }

          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    days[i],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...meals.map((meal) {
                    List<Widget> warnings = [];

                    if (isDiabetic && MealRules.isHighCarb(meal)) {
                      warnings.add(Text(
                        lang == 'ha'
                            ? "⚠ Gargadi: Wannan abinci yana da carbohydrates masu yawa"
                            : "⚠ High Carb (Diabetes caution)",
                        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                      ));
                    }

                    if (highBP && MealRules.isSalty(meal)) {
                      warnings.add(Text(
                        lang == 'ha'
                            ? "⚠ Gargaɗi: Yawan gishiri na iya ƙara hawan jini"
                            : "⚠ Reduce salt (High BP risk)",
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(meal, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ...warnings,
                        const SizedBox(height: 12),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
