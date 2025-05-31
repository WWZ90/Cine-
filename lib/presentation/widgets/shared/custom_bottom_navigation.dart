import 'package:flutter/material.dart';

import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final void Function(int, bool) onTap;

  const CustomBottomNavigation({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 18, 19, 24), // Fondo base
        border: const Border(
          top: BorderSide(
            color: Color.fromARGB(255, 28, 29, 34), // Línea sutil más clara
            width: 1,
          ),
        ),
      ),
      child: StylishBottomBar(
        option: AnimatedBarOptions(
          iconSize: 28,
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, 
        items: [
          BottomBarItem(
            icon: const Icon(Icons.movie_creation_outlined),
            selectedIcon: const Icon(
              Icons.movie_creation_rounded,
              color: Colors.white,
            ),
            selectedColor: Colors.white,
            title: Text(AppLocalizations.of(context)!.movies),
          ),
          BottomBarItem(
            icon: const Icon(Icons.movie_filter_outlined),
            selectedIcon: const Icon(Icons.movie_filter, color: Colors.white),
            selectedColor: Colors.white,
            title: Text(AppLocalizations.of(context)!.tvShows),
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_2_outlined),
            selectedIcon: const Icon(
              Icons.person_2_rounded,
              color: Colors.white,
            ),
            selectedColor: Colors.white,
            title: Text(AppLocalizations.of(context)!.actors),
          ),
          BottomBarItem(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite, color: Colors.red),
            selectedColor: Colors.white,
            title: Text(AppLocalizations.of(context)!.favorites),
          ),
        ],
        hasNotch: true,
        fabLocation: null,
        currentIndex: currentIndex,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          onTap(index, false);
        },
      ),
    );
  }
}
/*
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final void Function(int, bool) onTap;

  const CustomBottomNavigation({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      items: const [
        Column(children: [Icon(Icons.movie, size: 30), Text('Movies')]),
        Column(
          children: [
            Icon(Icons.tv, size: 30, color: Colors.amber,),
            Text('TVShows')
          ],
        ),
        Column(
          children: [
            Icon(Icons.person, size: 30),
            Text('Persons')
          ],
        ),
        Column(
          children: [
            Icon(Icons.favorite, size: 30),
            Text('Favorites')
          ],
        ),
      ],
      height: 50,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 250),
      backgroundColor: Colors.transparent,
      color: Theme.of(context).colorScheme.surface,
      onTap: (idx) {
        // goBranch recibe dos parámetros: el índice y si hace push
        onTap(idx, false);
      },
    );
  }
}
*/