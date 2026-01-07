import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/language_provider.dart';

import '../profile/profile_screen.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Listen for Authentication state (Login/Logout)
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show splash/loading while Firebase checks if a session exists
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // 2. If not logged in, go to Login
        if (user == null) {
          return const LoginScreen();
        }

        // 3. If logged in, check if they have finished setting up their profile
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('profiles')
              .doc(user.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const ProfileScreen();
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;
            final lang = data?['language'] as String?;
            if (lang != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<LanguageProvider>().setLanguage(lang);
              });
            }

            return const HomeScreen();
          },
        );
      },
    );
  }
}