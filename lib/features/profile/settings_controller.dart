import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Observables for state management
  var isDarkMode = false.obs;
  var currentLocale = const Locale('en', 'US').obs;

  // Dictionary for direct lookup of locale to lang_key for translating names
  final Map<Locale, String> availableLanguages = {
    const Locale('en', 'US'): 'lang_en',
    const Locale('ar', 'JO'): 'lang_ar',
  };

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void changeLanguage(Locale locale) {
    if (availableLanguages.containsKey(locale)) {
      currentLocale.value = locale;
      Get.updateLocale(locale);
    }
  }

  // Get current language name in the active language
  String getCurrentLanguageName() {
    final langKey = availableLanguages[currentLocale.value] ?? 'lang_en';
    return langKey.tr;
  }
}
