import 'dart:ui';
import 'package:cinemania/config/global_app_state.dart';
import 'package:cinemania/restart_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/datasources/isar_datasource.dart';
import 'package:cinemania/presentation/providers/providers.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  final isar = ref.read(isarDatasourceProvider);
  return LanguageNotifier(isar, ref);
});

class LanguageNotifier extends StateNotifier<Locale> {
  final IsarDatasource isar;
  final Ref ref;

  LanguageNotifier(this.isar, this.ref) : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final locale = await isar.getAppLocale();
    state = locale;
    GlobalAppState.currentLocale = locale;
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await isar.setAppLocale(locale);
  }
}
