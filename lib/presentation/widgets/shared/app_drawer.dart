import 'package:cinemania/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/config/app_info.dart';
import 'package:cinemania/config/global_app_state.dart';
import 'package:cinemania/presentation/providers/providers.dart';

class AppDrawer extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppDrawer({required this.navigationShell, super.key});

  Future<void> _setLanguage(WidgetRef ref, Locale locale) async {
    await ref.read(languageProvider.notifier).setLocale(locale);
  }

  Future<void> changeLanguageWithLoader({
    required BuildContext context,
    required WidgetRef ref,
    required Locale locale,
    required String currentLangCode,
  }) async {
    if (locale.languageCode == currentLangCode) {
      if (context.mounted) Navigator.pop(context);
      return;
    }

    GlobalAppState.suppressExitSnackbar = true;

    // Cerrar drawer
    if (context.mounted) Navigator.pop(context);

    // Esperar a que el drawer se cierre
    await Future.delayed(Duration.zero);

    // Mostrar loader inmediatamente
    if (context.mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          barrierDismissible: false,
          pageBuilder: (_, __, ___) => const TemporaryLoadingScreen(),
        ),
      );
    }

    // Capturar la función antes de posibles disposals
    final restartKeyNotifier = ref.read(appRestartKeyProvider);

    await Future.delayed(const Duration(milliseconds: 100));

    // Cambiar idioma y reiniciar
    await _setLanguage(ref, locale);

    // Ya no usamos ref aquí directamente
    restartKeyNotifier.value = UniqueKey();

    if (context.mounted) {
      Navigator.of(context).pop(); // Cierra TemporaryLoadingScreen
    }
  }

  void showAboutDialogWithAnimation() {
    final ctx = GlobalAppState.navigatorKey.currentContext;
    if (ctx == null) return;

    showGeneralDialog(
      context: ctx,
      barrierDismissible: true,
      barrierLabel: 'About',
      pageBuilder: (_, __, ___) {
        return FadeInUp(
          duration: const Duration(milliseconds: 300),
          child: AlertDialog(
            title: Row(
              children: [
                Image.asset('assets/images/app_icon.png', width: 40),
                const SizedBox(width: 12),
                Image.asset('assets/images/cine.png', width: 50),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(ctx)!.aboutTheApp,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(ctx)!.tmdb,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                Image.asset('assets/images/tmdb_logo.png', width: 100),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = GlobalAppState.currentLocale;
    final langCode = locale.languageCode;
    final currentIndex = navigationShell.currentIndex;

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appDrawer.png'),
                fit: BoxFit.cover,
              ),
            ),
            child:
                SizedBox.expand(), // ← esto expande al área completa del DrawerHeader
          ),

          // --- Secciones principales ---
          ListTile(
            leading: const Icon(Icons.movie),
            title: Text(AppLocalizations.of(context)!.movies),
            selected: currentIndex == 0,
            selectedTileColor: Colors.grey.shade900,
            onTap: () {
              GlobalAppState.suppressExitSnackbar = true;
              Navigator.pop(context);
              navigationShell.goBranch(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.tv),
            title: Text(AppLocalizations.of(context)!.tvShows),
            selected: currentIndex == 1,
            selectedTileColor: Colors.grey.shade900,
            onTap: () {
              GlobalAppState.suppressExitSnackbar = true;
              Navigator.pop(context);
              navigationShell.goBranch(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.actors),
            selected: currentIndex == 2,
            selectedTileColor: Colors.grey.shade900,
            onTap: () {
              GlobalAppState.suppressExitSnackbar = true;
              Navigator.pop(context);
              navigationShell.goBranch(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(AppLocalizations.of(context)!.favorites),
            selected: currentIndex == 3,
            selectedTileColor: Colors.grey.shade900,
            onTap: () {
              GlobalAppState.suppressExitSnackbar = true;
              Navigator.pop(context);
              navigationShell.goBranch(3);
            },
          ),

          const Divider(thickness: 1, color: Colors.blueGrey),

          // --- Ajustes y Lenguaje ---
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings),
            onTap: () {}, // Acción futura
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              AppLocalizations.of(context)!.language,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Text('🇪🇸', style: TextStyle(fontSize: 24)),
            title: const Text('Español'),
            trailing: langCode == 'es' ? const Icon(Icons.check) : null,
            onTap:
                () => changeLanguageWithLoader(
                  context: context,
                  ref: ref,
                  locale: const Locale('es'),
                  currentLangCode: langCode,
                ),
          ),
          ListTile(
            leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
            title: const Text('English'),
            trailing: langCode == 'en' ? const Icon(Icons.check) : null,
            onTap:
                () => changeLanguageWithLoader(
                  context: context,
                  ref: ref,
                  locale: const Locale('en'),
                  currentLangCode: langCode,
                ),
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppLocalizations.of(context)!.about),
            onTap: () {
              GlobalAppState.suppressExitSnackbar = true;
              Navigator.pop(context); // Cerramos el Drawer
              Future.delayed(const Duration(milliseconds: 100), () {
                showAboutDialogWithAnimation();
              });
            },
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${AppLocalizations.of(context)!.version}: ${AppInfo.version}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
