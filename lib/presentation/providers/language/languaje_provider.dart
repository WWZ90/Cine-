import 'package:cinemania/infrastructure/datasources/isar_datasource.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  final isar = ref.read(localStorageRepositoryProvider) as IsarDatasource;
  return LanguageNotifier(isar);
});

class LanguageNotifier extends StateNotifier<Locale> {
  final IsarDatasource isar;

  LanguageNotifier(this.isar) : super(Locale('es')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final locale = await isar.getAppLocale();
    state = locale;
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await isar.setAppLocale(locale);
  }
}