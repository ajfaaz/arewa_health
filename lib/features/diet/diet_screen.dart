import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart';
import 'diet_service.dart';

class DietScreen extends StatelessWidget {
  final bool diabetic;
  final bool highBP;
  final String lang;

  const DietScreen({
    super.key,
    required this.diabetic,
    required this.highBP,
    this.lang = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final service = DietService();
    final today = _getDayName(DateTime.now().weekday, lang);

    return Scaffold(
      appBar: AppBar(title: Text("${AppStrings.t("meal_plan", lang)} ($today)")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _mealCard(AppStrings.t("breakfast", lang),
              service.suggestMeal(diabetic: diabetic, highBP: highBP, category: "breakfast", lang: lang)),
          _mealCard(AppStrings.t("lunch", lang),
              service.suggestMeal(diabetic: diabetic, highBP: highBP, category: "lunch", lang: lang)),
          _mealCard(AppStrings.t("dinner", lang),
              service.suggestMeal(diabetic: diabetic, highBP: highBP, category: "dinner", lang: lang)),

          const SizedBox(height: 24),
          Text("🚫 ${AppStrings.t("foods_avoid", lang)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          ...service.getAvoidList(lang).map((food) => Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: Text(food),
                ),
              )),
        ],
      ),
    );
  }

  String _getDayName(int weekday, String lang) {
    if (lang == 'ha') {
      const days = ["Litinin", "Talata", "Laraba", "Alhamis", "Juma'a", "Asabar", "Lahadi"];
      return days[weekday - 1];
    }
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[weekday - 1];
  }

  Widget _mealCard(String title, meal) {
    if (meal == null) {
      return Card(
        child: ListTile(title: Text("$title: No safe meal found")),
      );
    }

    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(meal.name),
        trailing: Text("${meal.calories} kcal"),
      ),
    );
  }
}
