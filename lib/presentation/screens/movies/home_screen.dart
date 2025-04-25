import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  //Here is the entry point, so here we call all the data
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MoviesView());
  }
}
