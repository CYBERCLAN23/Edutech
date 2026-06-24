import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/services/local_storage_service.dart';
import 'package:educam_ai/services/translations.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

final translationsProvider = Provider<AppTranslations>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'fr' ? fr : en;
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(_load());

  static Locale _load() {
    final stored = LocalStorageService().getPref('locale');
    return stored == 'fr' ? const Locale('fr') : const Locale('en');
  }

  void setFr() => _set(const Locale('fr'));
  void setEn() => _set(const Locale('en'));

  void toggle() {
    _set(state.languageCode == 'fr' ? const Locale('en') : const Locale('fr'));
  }

  void _set(Locale locale) {
    state = locale;
    LocalStorageService().setPref('locale', locale.languageCode);
  }
}
