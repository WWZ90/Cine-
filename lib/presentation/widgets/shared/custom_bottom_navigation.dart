import 'package:flutter/material.dart';

import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

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
    return StylishBottomBar(
      option: AnimatedBarOptions(
        iconSize: 28,
        barAnimation: BarAnimation.fade,
        iconStyle: IconStyle.animated,
      ),
      backgroundColor: Colors.black12,
      items: [
        BottomBarItem(
          icon: const Icon(Icons.movie_creation_outlined),
          selectedIcon: const Icon(
            Icons.movie_creation_rounded,
            color: Colors.white,
          ),
          selectedColor: Colors.white,
          title: const Text('Películas'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.movie_filter_outlined),
          selectedIcon: const Icon(Icons.movie_filter, color: Colors.white),
          selectedColor: Colors.white,
          title: const Text('Series'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.person_2_outlined),
          selectedIcon: const Icon(Icons.person_2_rounded, color: Colors.white),
          selectedColor: Colors.white,
          title: const Text('Actores'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.favorite_border),
          selectedIcon: const Icon(Icons.favorite, color: Colors.red),
          selectedColor: Colors.white,
          title: const Text('Favoritos'),
        ),
      ],
      hasNotch: true,
      fabLocation: null,
      currentIndex: currentIndex,
      notchStyle: NotchStyle.circle,
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: [const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(255, 0, 0, 0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      onTap: (index) {
        onTap(index, false);
      },
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