import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class TVShowsViews extends ConsumerStatefulWidget {
  static const name = 'tv-shows-view';
  const TVShowsViews({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TVShowsViewsState();
}

class TVShowsViewsState extends ConsumerState<TVShowsViews> {
  @override
  Widget build(BuildContext context) {
    final airingToday = ref.watch(airingTodayTVShowsProvider);
    final onTheAir = ref.watch(onTheAirTVShowsProvider);
    final popular = ref.watch(popularTVShowsProvider);
    final topRated = ref.watch(topRatedTVShowsProvider);
    final genres = ref.watch(genresTVShowProvider);

    return CustomScrollView(
      slivers: [
        CustomAppbar(),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                TopSlideShow(allData: airingToday, type: 'TVShow'),
                SliderHorizontalListview(
                  allData: onTheAir,
                  type: 'TVShow',
                  title: 'On the air',
                  subTitle: 'This week',
                  loadNextPage: () {
                    ref.read(onTheAirTVShowsProvider.notifier).loadNextPage();
                  },
                ),
                SliderHorizontalListview(
                  allData: popular,
                  type: 'TVShow',
                  title: 'Popular',
                  subTitle: 'All time',
                  loadNextPage: () {
                    ref.read(popularTVShowsProvider.notifier).loadNextPage();
                  },
                ),
                GenresTab(genres: genres, type: 'TVShow'),
                SliderHorizontalListview(
                  allData: topRated,
                  type: 'TVShow',
                  title: 'Top Rated',
                  subTitle: 'All time',
                  loadNextPage: () {
                    ref.read(topRatedTVShowsProvider.notifier).loadNextPage();
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
