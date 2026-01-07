import 'diet_model.dart';

final Map<int, List<DietMeal>> weeklyMealPlan = {
  1: [ // Monday
    DietMeal(name: "Oatmeal + Groundnuts", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 300),
    DietMeal(name: "Tuwo Shinkafa + Miyan Kuka", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 450),
    DietMeal(name: "Boiled Yam + Vegetable Sauce", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 400),
  ],
  2: [ // Tuesday
    DietMeal(name: "Akamu (Pap) + Moi Moi", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 350),
    DietMeal(name: "Brown Rice + Vegetable Stew", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 500),
    DietMeal(name: "Grilled Fish + Steamed Vegetables", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 350),
  ],
  3: [ // Wednesday
    DietMeal(name: "Boiled Eggs (2) + Whole wheat bread", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 350),
    DietMeal(name: "Tuwo Dawa + Miyan Taushe", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 450),
    DietMeal(name: "Beans porridge (little oil)", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 400),
  ],
  4: [ // Thursday
    DietMeal(name: "Banana + Groundnuts", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 250),
    DietMeal(name: "Ofada/Brown Rice + Light Stew", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 500),
    DietMeal(name: "Boiled Sweet Potato + Vegetables", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 350),
  ],
  5: [ // Friday
    DietMeal(name: "Oats + Skimmed Milk", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 300),
    DietMeal(name: "Tuwo Masara + Miyan Wake", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 500),
    DietMeal(name: "Grilled Fish + Spinach", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 300),
  ],
  6: [ // Saturday
    DietMeal(name: "Egg Omelette (no oil)", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 250),
    DietMeal(name: "Beans + Plantain (small portion)", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 500),
    DietMeal(name: "Vegetable Soup (no swallow)", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 200),
  ],
  7: [ // Sunday
    DietMeal(name: "Whole wheat bread + Peanut butter", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 350),
    DietMeal(name: "Jollof Rice (small portion, low oil)", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 550),
    DietMeal(name: "Fruit salad (pawpaw, watermelon)", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 150),
  ],
};

final Map<int, List<DietMeal>> weeklyMealPlanHa = {
  1: [ // Litinin
    DietMeal(name: "Kunun oats da gyada", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 300),
    DietMeal(name: "Tuwo shinkafa da miyan kuka", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 450),
    DietMeal(name: "Dankali da aka dafa da miyar Ganye", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 400),
  ],
  2: [ // Talata
    DietMeal(name: "Koko/Kunu (akamu) da Kosai", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 350),
    DietMeal(name: "Shinkafa ruwan kasa(brown rice) da miyar Ganye", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 500),
    DietMeal(name: "Kifi da aka gasa + kayan lambu da aka turara", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 350),
  ],
  3: [ // Laraba
    DietMeal(name: "Kwai da aka dafa guda biyu + gurasar alkama", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 350),
    DietMeal(name: "Tuwon dawa da miyan kubewa", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 450),
    DietMeal(name: "Dafaffen Wake (ba mai yawa ba)", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 400),
  ],
  4: [ // Alhamis
    DietMeal(name: "Ayaba da gyada", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 250),
    DietMeal(name: "Shinkafa ruwan kasa (Ofada) da miya mara mai", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 500),
    DietMeal(name: "Dankalin Hausa da aka dafa + kayan lambu", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 350),
  ],
  5: [ // Juma'a
    DietMeal(name: "Kunun oats da madarar skim", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 300),
    DietMeal(name: "Tuwo masara da miyan Zogale", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 500),
    DietMeal(name: "Gasasshen Kifi + alayyahu", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 300),
  ],
  6: [ // Asabar
    DietMeal(name: "Soyayyen Kwai (ba mai)", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 250),
    DietMeal(name: "Wake da ayaba (Kadan)", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 500),
    DietMeal(name: "Miyar kayan lambu kawai (ba tuwo)", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 200),
  ],
  7: [ // Lahadi
    DietMeal(name: "Buredin Alkama da nikarkiyar gyada", category: "breakfast", diabeticSafe: true, bpSafe: true, calories: 350),
    DietMeal(name: "Shinkafar jollof (Kadan, mara mai sosai)", category: "lunch", diabeticSafe: true, bpSafe: true, calories: 550),
    DietMeal(name: "Hadi na 'ya'yan itatuwa", category: "dinner", diabeticSafe: true, bpSafe: true, calories: 150),
  ],
};

final List<String> foodsToAvoid = [
  "Sugary drinks",
  "White bread",
  "Excess garri",
  "Fried foods",
  "Processed snacks",
];

final List<String> foodsToAvoidHa = [
  "Abin sha mai sukari",
  "Farin Buredi",
  "Garin kwaki da yawa",
  "Soyayyen Abinci",
  "Abincin gwangwani",
];

// Flattened list for backward compatibility with existing filters
final List<DietMeal> nigerianMeals = weeklyMealPlan.values.expand((x) => x).toList();
