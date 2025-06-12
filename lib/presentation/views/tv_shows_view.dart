import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                TopSlideShow(allData: airingToday.shows, type: 'TVShow'),
                SizedBox(height: 20),
                SliderHorizontalListview(
                  allData: onTheAir.shows,
                  type: 'TVShow',
                  title: AppLocalizations.of(context)?.thisWeek,
                  subTitle: AppLocalizations.of(context)?.thisWeek,
                  isLoadingMore: onTheAir.isLoading,
                  loadNextPage: () {
                    ref.read(onTheAirTVShowsProvider.notifier).loadNextPage();
                  },
                ),
                SizedBox(height: 20),
                SliderHorizontalListview(
                  allData: popular.shows,
                  type: 'TVShow',
                  title: AppLocalizations.of(context)?.popular,
                  subTitle: AppLocalizations.of(context)?.allTime,
                  isLoadingMore: popular.isLoading,
                  loadNextPage: () {
                    ref.read(popularTVShowsProvider.notifier).loadNextPage();
                  },
                ),
                SizedBox(height: 15),
                GenresTab(genres: genres, type: 'TVShow'),
                SizedBox(height: 20),
                SliderHorizontalListview(
                  allData: topRated.shows,
                  type: 'TVShow',
                  title: AppLocalizations.of(context)?.topRated,
                  subTitle: AppLocalizations.of(context)?.allTime,
                  isLoadingMore: topRated.isLoading,
                  loadNextPage: () {
                    ref.read(topRatedTVShowsProvider.notifier).loadNextPage();
                  },
                ),
                SizedBox(height: 60),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
