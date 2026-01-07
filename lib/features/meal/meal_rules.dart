class MealRules {
  static bool isHighCarb(String meal) {
    final carbs = [
      'rice',
      'jollof',
      'tuwo',
      'shinkafa',
      'masara',
      'dawa',
      'yam',
      'sweet potato',
      'pap',
      'akamu',
      'bread',
      'gurasa',
      'plantain',
      'ayaba',
    ];

    return carbs.any(
      (c) => meal.toLowerCase().contains(c),
    );
  }

  static bool isSalty(String meal) {
    final saltyKeywords = [
      'jollof',
      'stew',
      'fried',
      'oil',
      'gasa',
      'miya'
    ];

    return saltyKeywords.any(
      (k) => meal.toLowerCase().contains(k),
    );
  }
}
