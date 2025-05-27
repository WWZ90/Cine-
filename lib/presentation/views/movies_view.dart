import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class MoviesView extends ConsumerStatefulWidget {
  const MoviesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<MoviesView> {
  @override
  Widget build(BuildContext context) {
    final nowPlaying = ref.watch(nowPlayingMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final genres = ref.watch(genresMovieProvider);

    return CustomScrollView(
      slivers: [
        CustomAppbar(),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                TopSlideShow(allData: nowPlaying.movies, type: 'Movie'),
                SizedBox(height: 20),
                SliderHorizontalListview(
                  allData: upcomingMovies.movies,
                  title: AppLocalizations.of(context)?.upcoming,
                  subTitle: AppLocalizations.of(context)?.soon,
                  type: 'Movie',
                  isLoadingMore: upcomingMovies.isLoading,
                  loadNextPage: () {
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                  },
                ),
                SizedBox(height: 20),
                SliderHorizontalListview(
                  allData: popularMovies.movies,
                  title: AppLocalizations.of(context)?.popular,
                  subTitle: AppLocalizations.of(context)?.popular,
                  type: 'Movie',
                  isLoadingMore: upcomingMovies.isLoading,
                  loadNextPage: () {
                    ref.read(popularMoviesProvider.notifier).loadNextPage();
                  },
                ),
                SizedBox(height: 15),
                GenresTab(genres: genres, type: 'Movie'),
                SizedBox(height: 20),
                SliderHorizontalListview(
                  allData: topRatedMovies.movies,
                  title: AppLocalizations.of(context)?.topRated,
                  subTitle: AppLocalizations.of(context)?.topRated,
                  type: 'Movie',
                  isLoadingMore: topRatedMovies.isLoading,
                  loadNextPage: () {
                    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                  },
                ),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
