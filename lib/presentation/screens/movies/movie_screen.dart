import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final Movie movie;
  const MovieScreen({super.key, required this.movie});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    final id = widget.movie.id.toString();
    ref.read(movieDetailProvider.notifier).loadMovie(id);
    ref.read(castByMovieProvider.notifier).loadActors(id);

    ref.read(videosMovieProvider(id));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(similarMoviesProvider(id).notifier).loadNextPage();
    });
    ref.read(reviewsByMovieProvider(id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _CustomSliverAppBar(movie: widget.movie));
  }
}

class _CustomSliverAppBar extends ConsumerStatefulWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  ConsumerState<_CustomSliverAppBar> createState() =>
      _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends ConsumerState<_CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final MovieDetail? movieDetails =
        ref.watch(movieDetailProvider)[widget.movie.id.toString()];

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: AppBarNetflix(
            minExtend: kToolbarHeight,
            maxExtend: size.height * 0.55, //0.35
            size: size,
            data: widget.movie,
            type: 'Movie',
          ),
        ),
        movieDetails != null
            ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [MovieDetailCard(movieDetails: movieDetails)],
                ),
              ),
            )
            : SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            ),
      ],
    );
  }
}
