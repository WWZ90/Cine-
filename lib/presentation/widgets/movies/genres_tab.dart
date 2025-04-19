import 'package:cinemania/domain/entities/genre.dart';
import 'package:cinemania/presentation/providers/genres/genres_movies_provider.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/movies/movies_providers.dart';

class GenresTab extends ConsumerStatefulWidget {
  final List<Genre> genres;
  const GenresTab({required this.genres, super.key});

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
      ref
          .read(moviesByGenreProvider(firstId.toString()).notifier)
          .loadNextPage();
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final newGenreId = widget.genres[_tabController.index].id;
        ref
            .read(moviesByGenreProvider(newGenreId.toString()).notifier)
            .loadNextPage();
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
                widget.genres
                    .map((g) => _GenreMoviesTab(genreId: g.id))
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class _GenreMoviesTab extends ConsumerWidget {
  final int genreId;
  const _GenreMoviesTab({required this.genreId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(moviesByGenreProvider(genreId.toString()));
    // while loading the first page, movies.isEmpty is our indicator
    if (movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return MoviesHorizontalListview(
      movies: movies,
      loadNextPage: () {
        ref
            .read(moviesByGenreProvider(genreId.toString()).notifier)
            .loadNextPage();
      },
    );
  }
}
