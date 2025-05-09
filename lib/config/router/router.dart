import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/views/views.dart';

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
        return InitialScreenLoader(navigationShell: navigationShell);
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
                GoRoute(
                  path: 'movie-video-screen',
                  name: 'movie-video-screen',
                  builder: (context, state) {
                    final videos = state.extra as List<Video>;
                    return VideosPage(videos: videos);
                  },
                ),
                GoRoute(
                  path: 'masonry-all-view',
                  name: 'masonry-all-view',
                  pageBuilder: (context, state) {
                    //final type = state.extra as String?;
                    //return MasonryAllView(type: type ?? '');

                    final extras = state.extra as Map<String, dynamic>?;

                    final type = extras?['type'] as String? ?? '';
                    final id = extras?['id'] as String? ?? '';

                    return CustomTransitionPage(
                      child: MasonryAllView(type: type, id: id),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    );
                    // return NoTransitionPage(
                    //   child: MasonryAllView(type: type, id: id),
                    // );
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
                GoRoute(
                  path: 'tv-show-video-screen',
                  name: 'tv-show-video-screen',
                  builder: (context, state) {
                    final videos = state.extra as List<Video>;
                    return VideosPage(videos: videos);
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
              routes: [
                GoRoute(
                  path: 'person-screen',
                  name: PersonScreen.name,
                  builder: (context, state) {
                    final extras = state.extra as Map<String, dynamic>?;

                    final id = extras?['id'] as int? ?? 0;
                    final name = extras?['name'] as String? ?? '';
                    final profilePath = extras?['profilePath'] as String? ?? '';
                    final popularity = extras?['popularity'] as double? ?? 0;
                    return PersonScreen(
                      id: id,
                      personName: name,
                      popularity: popularity,
                      profilePath: profilePath,
                    );
                  },
                ),
              ],
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
