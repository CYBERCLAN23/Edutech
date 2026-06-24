import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/services/local_storage_service.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_load());

  static ThemeMode _load() {
    final stored = LocalStorageService().getPref('theme_mode');
    switch (stored) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }

  void setDark() => _set(ThemeMode.dark);
  void setLight() => _set(ThemeMode.light);

  void toggle() {
    _set(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  void _set(ThemeMode mode) {
    state = mode;
    LocalStorageService().setPref('theme_mode', mode.name);
  }
}
