import 'package:cinemania/presentation/providers/persons/persons_provider.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InitialScreenLoader extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const InitialScreenLoader({super.key, required this.navigationShell});

  @override
  ConsumerState<InitialScreenLoader> createState() =>
      InitialScreenLoaderState();
}

class InitialScreenLoaderState extends ConsumerState<InitialScreenLoader> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(genresMovieProvider.notifier).loadGenres();

    ref.read(genresTVShowProvider.notifier).loadGenres();
    ref.read(airingTodayTVShowsProvider.notifier).loadNextPage();
    ref.read(onTheAirTVShowsProvider.notifier).loadNextPage();
    ref.read(popularTVShowsProvider.notifier).loadNextPage();
    ref.read(topRatedTVShowsProvider.notifier).loadNextPage();

    ref.read(personPopularProvider.notifier).loadNextPage();
    //ref.read(personTrendingProvider.notifier).loadNextPage();
    ref.read(curatedActorsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    final isFullScreen = ref.watch(isFullscreenProvider);

    if (initialLoading) {
      return Scaffold(body: FullScreenLoader());
    }

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar:
          isFullScreen
              ? null
              : CustomBottomNavigation(
                currentIndex: widget.navigationShell.currentIndex,
                onTap:
                    (idx, _) => widget.navigationShell.goBranch(
                      idx,
                      initialLocation: true,
                    ),
              ),
    );
  }
}
