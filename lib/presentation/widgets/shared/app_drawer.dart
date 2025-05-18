import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/config/global_app_state.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppDrawer({required this.navigationShell, super.key});

  Future<void> _setLanguage(WidgetRef ref, Locale locale) async {
    await ref.read(languageProvider.notifier).setLocale(locale);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = GlobalAppState.currentLocale;
    final langCode = locale.languageCode;

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appDrawer.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SizedBox(),
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
            onTap: () async {
              if (langCode != 'es') {
                await _setLanguage(ref, const Locale('es'));
                ref.read(appRestartKeyProvider).value = UniqueKey();
                navigationShell.goBranch(0); // 👈 Cambia a Home (películas)
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
            title: const Text('English'),
            trailing: langCode == 'en' ? const Icon(Icons.check) : null,
            onTap: () async {
              if (langCode != 'en') {
                await _setLanguage(ref, const Locale('en'));
                ref.read(appRestartKeyProvider).value = UniqueKey();
                navigationShell.goBranch(0); // 👈 Cambia a Home (películas)
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
