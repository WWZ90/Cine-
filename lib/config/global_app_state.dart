import 'dart:ui';

class GlobalAppState {
  static Locale currentLocale = const Locale('en');

  static String get languageCode {
    return currentLocale.languageCode == 'es' ? 'es-ES' : 'en-US';
  }
}