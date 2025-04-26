import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final initialLoading = ref.watch(initialLoadingProvider);

    if (initialLoading) return FullScreenLoader();

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
                TopSlideShow(allData: nowPlaying, type: 'Movie'),
                SliderHorizontalListview(
                  allData: upcomingMovies,
                  title: 'Upcoming',
                  subTitle: 'Soon',
                  type: 'Movie',
                  loadNextPage: () {
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                  },
                ),
                SliderHorizontalListview(
                  allData: popularMovies,
                  title: 'Populares',
                  subTitle: 'This month',
                  type: 'Movie',
                  loadNextPage: () {
                    ref.read(popularMoviesProvider.notifier).loadNextPage();
                  },
                ),
                SizedBox(height: 20),
                GenresTab(genres: genres, type: 'Movie'),
                SliderHorizontalListview(
                  allData: topRatedMovies,
                  title: 'Top Rated',
                  subTitle: 'All time',
                  type: 'Movie',
                  loadNextPage: () {
                    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                  },
                ),
                SizedBox(height: 10),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
