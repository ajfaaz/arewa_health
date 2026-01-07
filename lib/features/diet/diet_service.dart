import 'diet_data.dart';
import 'diet_rules.dart';
import 'diet_model.dart';

class DietService {
  DietMeal? suggestMeal({
    required bool diabetic,
    required bool highBP,
    required String category,
    String lang = 'en',
  }) {
    // 1. Try to get specific meal for today
    final weekday = DateTime.now().weekday;
    final plan = lang == 'ha' ? weeklyMealPlanHa : weeklyMealPlan;
    final dailyMeals = plan[weekday];

    if (dailyMeals != null) {
      try {
        final meal = dailyMeals.firstWhere((m) => m.category == category);

        // Check safety constraints
        bool safe = true;
        if (diabetic && !meal.diabeticSafe) safe = false;
        if (highBP && !meal.bpSafe) safe = false;

        if (safe) return meal;
      } catch (_) {}
    }

    // 2. Fallback to general filter
    final meals = filterMeals(
      diabetic: diabetic,
      highBP: highBP,
      category: category,
    );

    if (meals.isEmpty) return null;
    return meals.first;
  }

  List<String> getAvoidList(String lang) => lang == 'ha' ? foodsToAvoidHa : foodsToAvoid;
}
