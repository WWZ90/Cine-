import 'package:cinemania/presentation/views/views.dart';
import 'package:flutter/material.dart';

class HomeScreenTVShow extends StatelessWidget {
  static const name = 'home-screen-tv-show';
  const HomeScreenTVShow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TVShowsViews());
  }
}
