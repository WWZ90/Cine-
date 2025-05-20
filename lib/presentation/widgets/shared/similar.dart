import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Similar extends ConsumerWidget {
  final String id;
  final String type;
  const Similar({required this.id, required this.type, super.key});

  @override
  Widget build(BuildContext context, ref) {
    dynamic similar;
    type == 'Movie'
        ? similar = ref.watch(similarMoviesProvider(id))
        : similar = ref.watch(similarTVShowsProvider(id));

    if (type == 'Movie') {
      if (similar.isLoading && similar.movies.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
        );
      }

      if (!similar.isLoading && similar.movies.isEmpty) {
        //return const Center(child: Text('No similars movies'));
        return SizedBox();
      }
    } else {
      if (similar.isLoading && similar.shows.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
        );
      }

      if (!similar.isLoading && similar.shows.isEmpty) {
        //return const Center(child: Text('No similars tv shows'));
        return SizedBox();
      }
    }
    return SliderHorizontalListview(
      allData: type == 'Movie' ? similar.movies : similar.shows,
      title:
          type == 'Movie'
              ? AppLocalizations.of(context)!.similarMovies
              : AppLocalizations.of(context)!.similarTVShows,
      subTitle: 'All time',
      type: type,
      id: id,
      loadNextPage: () {
        type == 'Movie'
            ? ref.read(similarMoviesProvider(id).notifier).loadNextPage()
            : ref.read(similarTVShowsProvider(id).notifier).loadNextPage();
      },
    );
  }
}
