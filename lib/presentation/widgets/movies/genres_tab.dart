import 'package:cinemania/domain/entities/genre.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/movies/movies_providers.dart';

class GenresTab extends ConsumerStatefulWidget {
  final String type;
  final List<Genre> genres;
  const GenresTab({required this.type, required this.genres, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GenresTabState();
}

class _GenresTabState extends ConsumerState<GenresTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.genres.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firstId = widget.genres[0].id;

      if (widget.type == 'Movie') {
        ref
            .read(moviesByGenreProvider(firstId.toString()).notifier)
            .loadNextPage();
      }

      if (widget.type == 'TVShow') {
        ref
            .read(tvShowsByGenreProvider(firstId.toString()).notifier)
            .loadNextPage();
      }
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final newGenreId = widget.genres[_tabController.index].id;
        if (widget.type == 'Movie') {
          ref
              .read(moviesByGenreProvider(newGenreId.toString()).notifier)
              .loadNextPage();
        }
        if (widget.type == 'TVShow') {
          ref
              .read(tvShowsByGenreProvider(newGenreId.toString()).notifier)
              .loadNextPage();
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            tabs:
                widget.genres
                    .map((g) => Tab(text: g.name.toUpperCase()))
                    .toList(),
          ),
        ),
        SizedBox(
          height: 245,
          child: TabBarView(
            controller: _tabController,
            children:
                widget.genres.map((g) {
                  return widget.type == 'Movie'
                      ? _GenreTab(genreId: g.id, type: 'Movie')
                      : _GenreTab(genreId: g.id, type: 'TVShow');
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
      if (movies.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return SliderHorizontalListview(
        allData: movies,
        type: 'Movie',
        loadNextPage: () {
          ref
              .read(moviesByGenreProvider(genreId.toString()).notifier)
              .loadNextPage();
        },
      );
    } else {
      final tvShows = ref.watch(tvShowsByGenreProvider(genreId.toString()));
      if (tvShows.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return SliderHorizontalListview(
        allData: tvShows,
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
