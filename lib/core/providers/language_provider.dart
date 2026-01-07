import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const _key = 'app_language';
  String _lang = 'en';

  String get lang => _lang;

  LanguageProvider() {
    _loadLang();
  }

  Future<void> _loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString(_key) ?? 'en';
    notifyListeners();
  }

  Future<void> setLanguage(String newLang) async {
    if (_lang == newLang) return;

    _lang = newLang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newLang);

    notifyListeners();
  }
}
