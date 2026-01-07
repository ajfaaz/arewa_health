class AppStrings {
  static const Map<String, Map<String, String>> _data = {
    "en": {
      "home": "Home",
      "sleep": "Sleep Tracker",
      "bp": "Blood Pressure",
      "meal": "Meal Planner",
      "start_sleep": "Start Sleep",
      "stop_sleep": "Stop Sleep",
      "breakfast": "Breakfast",
      "lunch": "Lunch",
      "dinner": "Dinner",
      "foods_avoid": "Foods to Limit / Avoid",
      "meal_plan": "Meal Plan",
    },
    "ha": {
      "home": "Gida",
      "sleep": "Bibiyar Barci",
      "bp": "Hawan Jini",
      "meal": "Tsarin Abinci",
      "start_sleep": "Fara Barci",
      "stop_sleep": "Tsayar da Barci",
      "breakfast": "Karin kumallo",
      "lunch": "Abincin rana",
      "dinner": "Abincin dare",
      "foods_avoid": "Abinci da ake gujewa",
      "meal_plan": "Shirin Abinci",
    }
  };

  static String t(String key, String lang) {
    return _data[lang]?[key] ?? _data["en"]![key]!;
  }
}
