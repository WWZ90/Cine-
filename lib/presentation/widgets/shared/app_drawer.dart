import 'package:cinemania/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    final languageNotifier = ref.read(languageProvider.notifier);
    await languageNotifier.setLocale(locale);
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

    // Mostrar loader
    if (context.mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          barrierDismissible: false,
          pageBuilder: (_, __, ___) => const TemporaryLoadingScreen(),
        ),
      );
    }

    // Capturar el notifier antes de posibles disposals
    final restartKeyNotifier = ref.read(appRestartKeyProvider);

    await Future.delayed(const Duration(milliseconds: 100));

    // Cambiar idioma y reiniciar
    await _setLanguage(ref, locale);
    restartKeyNotifier.value = UniqueKey();

    // Redirigir a home y cerrar loader
    if (context.mounted) {
      context.go('/home');
      Navigator.of(context).pop();
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

  void _navigateToOscarsCategory(
    BuildContext context,
    String categoryNameEncoded,
    String? currentCategory,
  ) {
    GlobalAppState.suppressExitSnackbar = true;

    final expectedPath = '/oscars/$categoryNameEncoded';
    final currentPath = GoRouterState.of(context).uri.toString();
    const int oscarsBranchIndex = 5;

    if (currentPath == expectedPath &&
        navigationShell.currentIndex == oscarsBranchIndex) {
      Navigator.pop(context);
      navigationShell.goBranch(oscarsBranchIndex); // reafirma branch
      return;
    }

    Navigator.pop(context);

    // 🔥 Siempre aseguramos que estés en la branch 5
    navigationShell.goBranch(oscarsBranchIndex, initialLocation: false);

    // 🔥 Luego hacemos go a la ruta (NO push)
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.go(expectedPath);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = GlobalAppState.currentLocale;
    final langCode = locale.languageCode;
    final currentIndex = navigationShell.currentIndex;
    final isPremiumSelected = currentIndex == 4;
    final isOscarsSelected = currentIndex == 5;
    bool isOscarsCategoryActive = false;
    String? activeOscarsCategoryPathParameter;

    final currentRoute = GoRouterState.of(context).uri.toString();
    final currentShellIndex = navigationShell.currentIndex;

    final Map<String, String> oscarCategories = {
      'Best Picture': l10n.bestPictureLabel,
      'Animated Feature Film': l10n.animatedFeatureFilmLabel,
      'Best Visual Effects': l10n.visualEffectsLabel,
      'Best Director': l10n.directingLabel,
      // Añade más categorías aquí a medida que las implementes
    };

    if (currentRoute.startsWith('/oscars/')) {
      isOscarsCategoryActive = true;
      // Extraer el parámetro de categoría de la ruta si existe
      // Esto es un ejemplo simple, tu lógica de extracción puede ser más robusta
      try {
        final parts = currentRoute.split('/');
        if (parts.length > 2 && parts[1] == 'oscars') {
          activeOscarsCategoryPathParameter = Uri.decodeComponent(parts[2]);
        }
      } catch (e) {
        // ignore: avoid_print
        print('Error parsing oscars category from route: $e');
      }
    }

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  ListTile(
                    leading: Icon(
                      Icons.workspace_premium_outlined,
                      color: isPremiumSelected ? Colors.black : Colors.amber,
                    ),
                    title: Text(AppLocalizations.of(context)!.becomePremium),
                    selected: currentIndex == 4,
                    selectedTileColor: const Color.fromARGB(255, 241, 203, 86),
                    selectedColor: Colors.black,
                    onTap: () {
                      GlobalAppState.suppressExitSnackbar = true;
                      Navigator.pop(context);
                      navigationShell.goBranch(4);
                    },
                  ),

                  // ListTile(
                  //   leading: Icon(
                  //     Icons.auto_awesome_outlined,
                  //     color: isOscarsSelected ? Colors.black : Colors.amber,
                  //   ),
                  //   title: Text(AppLocalizations.of(context)!.oscars),
                  //   selected: currentIndex == 5,
                  //   selectedTileColor: const Color.fromARGB(255, 241, 203, 86),
                  //   selectedColor: Colors.black,
                  //   onTap: () {
                  //     GlobalAppState.suppressExitSnackbar = true;
                  //     Navigator.pop(context);
                  //     navigationShell.goBranch(5);
                  //   },
                  // ),
                  Column(
                    children: [
                      const Divider(height: 1),
                      Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          key: const PageStorageKey<String>(
                            'oscars_expansion_tile',
                          ),
                          leading: const Icon(
                            Icons.auto_awesome_outlined,
                            color: Colors.amber,
                          ),
                          title: Text(
                            l10n.oscars,
                            style: TextStyle(
                              fontWeight:
                                  isOscarsCategoryActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          children:
                              oscarCategories.entries.map((entry) {
                                final categoryKey = entry.key;
                                final categoryDisplay = entry.value;
                                final categoryPathParameter =
                                    Uri.encodeComponent(categoryKey);

                                final isSelected =
                                    isOscarsCategoryActive &&
                                    activeOscarsCategoryPathParameter ==
                                        categoryKey;

                                final icon =
                                    oscarCategoryIcons[categoryKey] ??
                                    Icons.label_outline;

                                return Material(
                                  color:
                                      isSelected
                                          ? (const Color.fromARGB(
                                            255,
                                            53,
                                            51,
                                            45,
                                          )?.withOpacity(0.5))
                                          : Colors.transparent,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                      left: 52.0,
                                    ),
                                    leading: Icon(
                                      icon,
                                      color: Colors.amber[300],
                                    ),
                                    title: Text(categoryDisplay),
                                    selected: isSelected,
                                    onTap:
                                        () => _navigateToOscarsCategory(
                                          context,
                                          categoryPathParameter,
                                          activeOscarsCategoryPathParameter,
                                        ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, color: Colors.blueGrey),

                  // --- Ajustes y Lenguaje ---
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(AppLocalizations.of(context)!.settings),
                    onTap: () {}, // Acción futura
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.language,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '${AppLocalizations.of(context)!.version}: ${AppInfo.version}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final Map<String, IconData> oscarCategoryIcons = {
  'Best Picture': Icons.movie_filter_outlined,
  'Animated Feature Film': Icons.animation_outlined,
  'Best Visual Effects': Icons.auto_awesome_outlined,
  'Best Director': Icons.chair_outlined,
  'Best Actor / Actress': Icons.person_outline,
  'Best Original Screenplay': Icons.edit_note_outlined,
};
