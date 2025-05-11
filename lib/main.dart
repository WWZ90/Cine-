import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:cinemania/config/router/router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cinemania/config/helpers/file_storage.dart';
import 'package:cinemania/config/theme/app_theme.dart';
import 'package:y_player/y_player.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  await LocalImageFileManager.init();
  YPlayerInitializer.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = AppTheme();
    return MaterialApp.router(
      routerConfig: appRouter,
      locale: ref.watch(languageProvider),
      supportedLocales: const [Locale('en'), Locale('es')],
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
    );
  }
}
