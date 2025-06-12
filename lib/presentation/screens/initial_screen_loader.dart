import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class InitialScreenLoader extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const InitialScreenLoader({super.key, required this.navigationShell});

  @override
  ConsumerState<InitialScreenLoader> createState() =>
      InitialScreenLoaderState();
}

class InitialScreenLoaderState extends ConsumerState<InitialScreenLoader> {
  final ValueNotifier<bool> showNav = ValueNotifier(true);
  bool initialCheckDone = false;
  bool shouldShowLoader = true;
  bool showRestartMessage = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      ref.read(nowPlayingMoviesProvider.notifier).reset();
      ref.read(upcomingMoviesProvider.notifier).reset();
      ref.read(popularMoviesProvider.notifier).reset();
      ref.read(topRatedMoviesProvider.notifier).reset();

      ref.read(genresMovieProvider.notifier).loadGenres();
      ref.read(genresTVShowProvider.notifier).loadGenres();

      ref.read(airingTodayTVShowsProvider.notifier).reset();
      ref.read(onTheAirTVShowsProvider.notifier).reset();
      ref.read(popularTVShowsProvider.notifier).reset();
      ref.read(topRatedTVShowsProvider.notifier).reset();

      ref.read(personPopularProvider.notifier).reset();

      ref.invalidate(movieDetailProvider);
      ref.invalidate(tvShowDetailsProvider);
      ref.invalidate(personDetailProvider);
      ref.invalidate(reviewsByMovieProvider);
      ref.invalidate(reviewsByTVShowProvider);

      ref.invalidate(movieProvider);
      ref.invalidate(similarMoviesProvider);
      ref.invalidate(similarTVShowsProvider);
      ref.invalidate(moviesCrewByPersonGroupedProvider);
      ref.invalidate(movieCreditsProvider);
      ref.invalidate(tvShowCreditsProvider);

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showRestartMessage = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFullScreen = ref.watch(isFullscreenProvider);
    final isLoading = ref.watch(initialLoadingProvider);
    final currentShellIndex = widget.navigationShell.currentIndex;

    final location = GoRouterState.of(context).uri.toString();

    final showBottomNav =
        ['/home', '/tv', '/persons', '/favorites'].contains(location) && !isFullScreen;

    if (isLoading) {
      return Scaffold(
        body: Stack(children: [FullScreenLoader(context: context)]),
      );
    }

    return Scaffold(
      drawer: AppDrawer(navigationShell: widget.navigationShell),
      body: Stack(
        children: [
          widget.navigationShell,
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child:
                  showBottomNav
                      ? CustomBottomNavigation(
                        key: const ValueKey('bottom_nav'),
                        currentIndex: currentShellIndex,
                        onTap:
                            (idx, _) => widget.navigationShell.goBranch(
                              idx,
                              initialLocation: true,
                            ),
                      )
                      : const SizedBox(key: ValueKey('empty'), height: 0),
            ),
          ),
        ],
      ),
    );
  }
}
