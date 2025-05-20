import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class GenresTab extends ConsumerStatefulWidget {
  final String type;
  final List<Genre> genres;
  const GenresTab({required this.type, required this.genres, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GenresTabState();
}

class _GenresTabState extends ConsumerState<GenresTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final genres = widget.genres;

    if (genres.isEmpty) {
      return const SizedBox(
        height: 253,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
      );
    }

    // Crea el TabController cuando ya hay géneros disponibles
    _tabController ??= TabController(length: genres.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController!.indexIsChanging == false) {
        final selectedId = genres[_tabController!.index].id;
        if (widget.type == 'Movie') {
          ref
              .read(moviesByGenreProvider(selectedId.toString()).notifier)
              .loadNextPage();
        } else {
          ref
              .read(tvShowsByGenreProvider(selectedId.toString()).notifier)
              .loadNextPage();
        }
      }
    });

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        final newGenreId = genres[_tabController!.index].id;
        if (widget.type == 'Movie') {
          ref
              .read(moviesByGenreProvider(newGenreId.toString()).notifier)
              .loadNextPage();
        } else {
          ref
              .read(tvShowsByGenreProvider(newGenreId.toString()).notifier)
              .loadNextPage();
        }
      }
    });

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: _tabController,
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.zero,
            indicatorWeight: 1.0,
            indicatorAnimation: TabIndicatorAnimation.elastic,
            labelColor: Colors.white,
            tabs: genres.map((g) => Tab(text: g.name.toUpperCase())).toList(),
          ),
        ),
        SizedBox(
          height: 253,
          child: TabBarView(
            controller: _tabController,
            children:
                genres.map((g) {
                  return widget.type == 'Movie'
                      ? _GenreTab(genreId: g.id, type: 'Movie')
                      : _GenreTab(
                        genreId: g.id,
                        type: 'TVShow',
                      );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

class _GenreTab extends ConsumerWidget {
  final String type;
  final int genreId;

  const _GenreTab({required this.type, required this.genreId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (type == 'Movie') {
      final movies = ref.watch(moviesByGenreProvider(genreId.toString()));
      if (movies.isLoading && movies.movies.isEmpty) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 1));
      }
      return SliderHorizontalListview(
        allData: movies.movies,
        type: 'Movie',
        loadNextPage: () {
          ref
              .read(moviesByGenreProvider(genreId.toString()).notifier)
              .loadNextPage();
        },
      );
    } else {
      final tvShows = ref.watch(tvShowsByGenreProvider(genreId.toString()));
      if (tvShows.isLoading && tvShows.shows.isEmpty) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 1));
      }
      return SliderHorizontalListview(
        allData: tvShows.shows,
        type: 'TVShow',
        loadNextPage: () {
          ref
              .read(tvShowsByGenreProvider(genreId.toString()).notifier)
              .loadNextPage();
        },
      );
    }
  }
}
