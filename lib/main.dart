import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_gate.dart';
import 'package:provider/provider.dart';
import 'core/providers/language_provider.dart';
import 'features/notifications/notification_service.dart';
import 'features/sleep/sleep_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  setupHealthNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => SleepService()),
      ],
      child: const ArewaHealthApp(),
    ),
  );
}

class ArewaHealthApp extends StatelessWidget {
  const ArewaHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arewa Health',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

void setupHealthNotifications() {
  // 🍲 MEALS
  NotificationService.scheduleDaily(
    id: 1,
    title: "🍲 Breakfast Reminder",
    body: "Choose a low-salt healthy breakfast",
    hour: 8,
    minute: 0,
  );

  NotificationService.scheduleDaily(
    id: 2,
    title: "🍛 Lunch Reminder",
    body: "Balanced carbs help control BP & sugar",
    hour: 13,
    minute: 0,
  );

  NotificationService.scheduleDaily(
    id: 3,
    title: "🍲 Dinner Reminder",
    body: "Avoid heavy meals at night",
    hour: 19,
    minute: 0,
  );

  // ❤️ BP
  NotificationService.scheduleDaily(
    id: 4,
    title: "❤️ Blood Pressure",
    body: "Please record your BP today",
    hour: 10,
    minute: 0,
  );

  // 😴 SLEEP
  NotificationService.scheduleDaily(
    id: 5,
    title: "😴 Sleep Tracking",
    body: "Start sleep tracking for better recovery",
    hour: 22,
    minute: 0,
  );
}
