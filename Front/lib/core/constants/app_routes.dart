import 'package:flutter/material.dart';
import '../../presentation/pages/login_screen.dart';
import '../../presentation/pages/register_screen.dart';
import '../../presentation/pages/home_screen.dart';
import '../../presentation/pages/settings_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }

  static String getInitialRoute() {
    return login;
  }
}
