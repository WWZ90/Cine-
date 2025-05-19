import 'package:cinemania/config/global_app_state.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/views/views.dart';
import 'package:cinemania/presentation/providers/providers.dart';

// Llaves de navegadores para estado independiente
final _branchNavigatorKeys = [
  GlobalKey<NavigatorState>(), // Home - Movies
  GlobalKey<NavigatorState>(), // TV Shows
  GlobalKey<NavigatorState>(), // Persons
  GlobalKey<NavigatorState>(), // Favorites
];

final GoRouter appRouter = GoRouter(
  navigatorKey: GlobalAppState.navigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        DateTime? lastBackPressTime;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (_, __) async {
            if (navigationShell.currentIndex > 0) {
              navigationShell.goBranch(0);
              return;
            }

            if (GlobalAppState.suppressExitSnackbar) {
              GlobalAppState.suppressExitSnackbar = false;
              return;
            }

            final now = DateTime.now();
            final shouldExit =
                lastBackPressTime == null ||
                now.difference(lastBackPressTime!) > const Duration(seconds: 2);

            if (shouldExit) {
              lastBackPressTime = now;

              if (context.mounted) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.pressAgainToExit,
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
              }

              return;
            }

            SystemNavigator.pop();
          },
          child: Consumer(
            builder: (context, ref, _) {
              final restartKey = ref.watch(appRestartKeyProvider);
              return InitialScreenLoader(
                key: restartKey.value,
                navigationShell: navigationShell,
              );
            },
          ),
        );
      },
      branches: [
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
                  },
                ),
              ],
            ),
          ],
        ),
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
