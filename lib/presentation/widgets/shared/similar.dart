import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    if (similar.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return SliderHorizontalListview(
      allData: similar,
      title: type == 'Movie' ? 'Similar movies' : 'Similar TVShow',
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
