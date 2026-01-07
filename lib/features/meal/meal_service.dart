import 'meal_data.dart';

class MealService {
  static List<String> getMealsForDay(String lang, String day) {
    return MealData.weeklyMeals[lang]?[day] ?? [];
  }

  static List<String> getDays(String lang) {
    return MealData.weeklyMeals[lang]?.keys.toList() ?? [];
  }
}
