import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides app locale state management with persistence
/// Auto-disposes when not used to save memory
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale> {
  static const String _localeKey = 'app_locale';

  @override
  Locale build() {
    // Load saved locale asynchronously
    _loadSavedLocale();
    // Return default locale immediately
    return const Locale('hi');
  }

  /// Load saved locale from shared preferences
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);
      if (savedLocale != null && savedLocale != state.languageCode) {
        state = Locale(savedLocale);
      }
    } catch (e) {
      // If loading fails, keep default locale
      debugPrint('Error loading saved locale: $e');
    }
  }

  /// Save locale to shared preferences
  Future<void> _saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  /// Set app locale and persist to storage
  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _saveLocale(locale);
  }

  /// Toggle between English and Hindi
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'en'
        ? const Locale('hi')
        : const Locale('en');
    await setLocale(newLocale);
  }
}
