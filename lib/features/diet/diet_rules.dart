import 'package:arewa_health/features/diet/diet_data.dart';

import 'diet_model.dart';

List<DietMeal> filterMeals({
  required bool diabetic,
  required bool highBP,
  required String category,
}) {
  return nigerianMeals.where((meal) {
    if (meal.category != category) return false;
    if (diabetic && !meal.diabeticSafe) return false;
    if (highBP && !meal.bpSafe) return false;
    return true;
  }).toList();
}
