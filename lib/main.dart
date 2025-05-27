import 'package:flutter/material.dart';
import 'package:cinemania/config/global_app_state.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/config/router/router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(systemNavigationBarColor: Color(0xFF121318)),
  );

  final locale = await isarSingleton.getAppLocale();
  GlobalAppState.currentLocale = locale;

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restartKey = ref.watch(appRestartKeyProvider); // 🔁 fuerza reinicio
    final locale = ref.watch(languageProvider); // 🌐 idioma dinámico
    final appTheme = AppTheme();

    bool defaultOnNavigationNotification(NavigationNotification _) {
      switch (WidgetsBinding.instance.lifecycleState) {
        case null:
        case AppLifecycleState.detached:
        case AppLifecycleState.inactive:
          // Evita cerrar la app cuando no está lista
          return true;
        case AppLifecycleState.resumed:
        case AppLifecycleState.hidden:
        case AppLifecycleState.paused:
          SystemNavigator.setFrameworkHandlesBack(true);
          return true;
      }
    }

    return ValueListenableBuilder<Key>(
      valueListenable: restartKey,
      builder: (context, key, _) {
        return MaterialApp.router(
          onNavigationNotification: defaultOnNavigationNotification,
          key: key, // ← reinicia todo el árbol
          routerConfig: appRouter,
          locale: locale, // ← usa el provider, no GlobalAppState
          supportedLocales: const [Locale('en'), Locale('es')],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: appTheme.getTheme(),
        );
      },
    );
  }
}
