/*
import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/views/views.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => HomeScreen(childView: MoviesView()),
      routes: [
        GoRoute(
          path: 'movie-screen',
          name: MovieScreen.name,
          builder: (context, state) {
            final movie = state.extra as Movie;
            return MovieScreen(movie: movie);
          },
        ),
        GoRoute(
          path: 'video-screen',
          name: VideosPage.name,
          builder: (context, state) => VideosPage(),
        ),
      ],
    ),
  ],
);
*/

// lib/config/router.dart

import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/screens/tv_shows/tv_show_screen.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/presentation/views/favorites_view.dart';
import 'package:cinemania/presentation/views/persons_view.dart';
import 'package:cinemania/presentation/views/tv_shows_view.dart';

// Llaves de navegadores para estado independiente
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _branchNavigatorKeys = [
  GlobalKey<NavigatorState>(), // Home - Movies
  GlobalKey<NavigatorState>(), // TV Shows
  GlobalKey<NavigatorState>(), // Persons
  GlobalKey<NavigatorState>(), // Favorites
];

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: navigationShell.currentIndex,
            onTap:
                (idx, _) =>
                    navigationShell.goBranch(idx, initialLocation: idx == 0),
          ),
        );
      },
      branches: [
        // Branch 0: Home / Movies
        StatefulShellBranch(
          navigatorKey: _branchNavigatorKeys[0],
          routes: [
            GoRoute(
              path: '/home',
              name: HomeScreen.name,
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'movie-screen',
                  name: MovieScreen.name,
                  builder: (context, state) {
                    final movie = state.extra as Movie;
                    return MovieScreen(movie: movie);
                  },
                ),
              ],
            ),
          ],
        ),
        // Branch 1: TV Shows
        StatefulShellBranch(
          navigatorKey: _branchNavigatorKeys[1],
          routes: [
            GoRoute(
              path: '/tv',
              name: TVShowsViews.name,
              builder: (context, state) => const TVShowsViews(),
              routes: [
                GoRoute(
                  path: 'tv-show-screen',
                  name: TVShowScreen.name,
                  builder: (context, state) {
                    final tvShow = state.extra as TVShow;
                    return TVShowScreen(tvShow: tvShow);
                  },
                ),
              ],
            ),
          ],
        ),
        // Branch 2: Persons / Actors
        StatefulShellBranch(
          navigatorKey: _branchNavigatorKeys[2],
          routes: [
            GoRoute(
              path: '/persons',
              name: PersonsViews.name,
              builder: (context, state) => const PersonsViews(),
            ),
          ],
        ),
        // Branch 3: Favorites
        StatefulShellBranch(
          navigatorKey: _branchNavigatorKeys[3],
          routes: [
            GoRoute(
              path: '/favorites',
              name: FavoritesView.name,
              builder: (context, state) => const FavoritesView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
