import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class MasonryAllView extends ConsumerStatefulWidget {
  final String? type;
  final String id;
  const MasonryAllView({required this.type, this.id = '', super.key});

  @override
  ConsumerState<MasonryAllView> createState() => _MasonryAllViewState();
}

class _MasonryAllViewState extends ConsumerState<MasonryAllView> {
  final scrollController = ScrollController();

  bool isLoading = false;

  void loadNextPage() async {
    if (isLoading) return;
    isLoading = true;

    if (widget.type == '${AppLocalizations.of(context)!.upcoming}-Movie') {
      await ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    } else if (widget.type == '${AppLocalizations.of(context)!.popular}-Movie') {
      await ref.read(popularMoviesProvider.notifier).loadNextPage();
    } else if (widget.type == '${AppLocalizations.of(context)!.topRated}-Movie') {
      await ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    } else if (widget.type == '${AppLocalizations.of(context)!.similarMovies}-Movie') {
      await ref.read(similarMoviesProvider(widget.id).notifier).loadNextPage();
    } else if (widget.type == '${AppLocalizations.of(context)!.thisWeek}-TVShow') {
      await ref.read(onTheAirTVShowsProvider.notifier).loadNextPage();
    } else if (widget.type == '${AppLocalizations.of(context)!.popular}-TVShow') {
      await ref.read(popularTVShowsProvider.notifier).loadNextPage();
    } else if (widget.type == '${AppLocalizations.of(context)!.topRated}-TVShow') {
      await ref.read(topRatedTVShowsProvider.notifier).loadNextPage();
    } else if (widget.type == '${AppLocalizations.of(context)!.similarTVShows}-TVShow') {
      await ref.read(similarTVShowsProvider(widget.id).notifier).loadNextPage();
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
    if (widget.type == '${AppLocalizations.of(context)!.upcoming}-Movie') {
      allData = ref.watch(upcomingMoviesProvider).movies;
    } else if (widget.type == '${AppLocalizations.of(context)!.popular}-Movie') {
      allData = ref.watch(popularMoviesProvider).movies;
    } else if (widget.type == '${AppLocalizations.of(context)!.topRated}-Movie') {
      allData = ref.watch(topRatedMoviesProvider).movies;
    } else if (widget.type == '${AppLocalizations.of(context)!.similarMovies}-Movie') {
      allData = ref.watch(similarMoviesProvider(widget.id)).movies;
    } else if (widget.type == '${AppLocalizations.of(context)!.thisWeek}-TVShow') {
      allData = ref.watch(onTheAirTVShowsProvider).shows;
    } else if (widget.type == '${AppLocalizations.of(context)!.popular}-TVShow') {
      allData = ref.watch(popularTVShowsProvider).shows;
    } else if (widget.type == '${AppLocalizations.of(context)!.topRated}-TVShow') {
      allData = ref.watch(topRatedTVShowsProvider).shows;
    } else if (widget.type == '${AppLocalizations.of(context)!.similarTVShows}-TVShow') {
      allData = ref.watch(similarTVShowsProvider(widget.id)).shows;
    }

    if (allData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: MasonryView(
        key: ValueKey(widget.type), // evita reanimar si no cambió el tipo
        loadNextPage: loadNextPage,
        data: allData,
      ),
    );
  }
}
