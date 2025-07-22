import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PreferencesService {
  static const String _darkModeKey = 'dark_mode';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _autoSaveKey = 'auto_save_enabled';
  static const String _languageKey = 'selected_language';
  static const String _fontSizeKey = 'font_size';

  // Singleton pattern
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  SharedPreferences? _prefs;

  // Inicializa as preferências
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Getters para as preferências
  bool get isDarkMode => _prefs?.getBool(_darkModeKey) ?? false;
  bool get isNotificationsEnabled => _prefs?.getBool(_notificationsKey) ?? true;
  bool get isAutoSaveEnabled => _prefs?.getBool(_autoSaveKey) ?? true;
  String get selectedLanguage => _prefs?.getString(_languageKey) ?? 'Português';
  double get fontSize => _prefs?.getDouble(_fontSizeKey) ?? 16.0;

  // Setters para as preferências
  Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(_darkModeKey, value);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs?.setBool(_notificationsKey, value);
  }

  Future<void> setAutoSaveEnabled(bool value) async {
    await _prefs?.setBool(_autoSaveKey, value);
  }

  Future<void> setSelectedLanguage(String value) async {
    await _prefs?.setString(_languageKey, value);
  }

  Future<void> setFontSize(double value) async {
    await _prefs?.setDouble(_fontSizeKey, value);
  }

  // Limpa todas as preferências (usado no logout)
  Future<void> clearAllPreferences() async {
    await _prefs?.remove(_darkModeKey);
    await _prefs?.remove(_notificationsKey);
    await _prefs?.remove(_autoSaveKey);
    await _prefs?.remove(_languageKey);
    await _prefs?.remove(_fontSizeKey);
  }

  // Método para obter tema baseado na preferência
  ThemeData getTheme() {
    if (isDarkMode) {
      return ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          fontSizeFactor: fontSize / 16.0,
        ),
      );
    } else {
      return ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          fontSizeFactor: fontSize / 16.0,
        ),
      );
    }
  }
}
