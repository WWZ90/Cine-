import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class MasonryAllView extends ConsumerStatefulWidget {
  final String? type;
  const MasonryAllView({required this.type, super.key});

  @override
  ConsumerState<MasonryAllView> createState() => _MasonryAllViewState();
}

class _MasonryAllViewState extends ConsumerState<MasonryAllView> {
  final scrollController = ScrollController();
  
  bool isLoading = false;

  void loadNextPage() async {
    if (isLoading) return;
    isLoading = true;

    if (widget.type == 'Próximamente-Movie') {
      await ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    } else if (widget.type == 'Populares-Movie') {
      await ref.read(popularMoviesProvider.notifier).loadNextPage();
    } else if (widget.type == 'Mejores Valoradas-Movie') {
      await ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    } else if (widget.type == 'En esta semana-TVShow') {
      await ref.read(onTheAirTVShowsProvider.notifier).loadNextPage();
    } else if (widget.type == 'Populares-TVShow') {
      await ref.read(popularTVShowsProvider.notifier).loadNextPage();
    } else if (widget.type == 'Mejores valoradas-TVShow') {
      await ref.read(topRatedTVShowsProvider.notifier).loadNextPage();
    }

    isLoading = false;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic allData;
    if (widget.type == 'Próximamente-Movie') {
      allData = ref.watch(upcomingMoviesProvider);
    } else if (widget.type == 'Populares-Movie') {
      allData =  ref.watch(popularMoviesProvider);
    } else if (widget.type == 'Mejores valoradas-Movie') {
      allData =  ref.watch(topRatedMoviesProvider);
    } else if (widget.type == 'En esta semana-TVShow') {
      allData = ref.watch(onTheAirTVShowsProvider);
    } else if (widget.type == 'Populares-TVShow') {
      allData = ref.watch(popularTVShowsProvider);
    } else if (widget.type == 'Mejores valoradas-TVShow') {
      allData = ref.watch(topRatedTVShowsProvider);
    }

    if (allData.isEmpty) {
      return SizedBox();
    }

    return Scaffold(
      body: MasonryView(loadNextPage: loadNextPage, data: allData),
    );
  }
}
