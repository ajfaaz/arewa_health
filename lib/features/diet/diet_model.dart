class DietMeal {
  final String name;
  final String category; // breakfast, lunch, dinner
  final bool diabeticSafe;
  final bool bpSafe;
  final int calories;

  DietMeal({
    required this.name,
    required this.category,
    required this.diabeticSafe,
    required this.bpSafe,
    required this.calories,
  });
}
