import 'package:flutter/material.dart';

class GlobalAppState {
  static Locale currentLocale = const Locale('en');
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static bool suppressExitSnackbar = false;

  static String get languageCode {
    return currentLocale.languageCode == 'es' ? 'es-ES' : 'en-US';
  }
}