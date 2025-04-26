import 'package:flutter/material.dart';
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
        Icon(Icons.movie, size: 30),
        Icon(Icons.tv, size: 30),
        Icon(Icons.person, size: 30),
        Icon(Icons.favorite, size: 30),
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