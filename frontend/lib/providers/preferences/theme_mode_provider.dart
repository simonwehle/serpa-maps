import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = themeMode;
  }

  Future<void> loadThemeModeFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? themeString = prefs.getString('ThemeMode');
    if (themeString != null) {
      switch (themeString) {
        case 'ThemeMode.light':
          state = ThemeMode.light;
          break;
        case 'ThemeMode.dark':
          state = ThemeMode.dark;
          break;
        case 'ThemeMode.system':
        default:
          state = ThemeMode.system;
      }
    }
  }
}
