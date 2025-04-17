import 'dart:math';

import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/presentation/providers/movies/movie_detail_provider.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  //final String movieId;
  final Movie movie;
  const MovieScreen({super.key, required this.movie});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(movieDetailProvider.notifier)
        .loadMovie(widget.movie.id.toString());
    ref
        .read(videosMovieProvider.notifier)
        .loadVideosMovie(widget.movie.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movieDetails =
        ref.watch(movieDetailProvider)[widget.movie.id.toString()];

    final List<Video> videos = ref.watch(videosMovieProvider);

    return Scaffold(
      body: _CustomSliverAppBar(
        movie: widget.movie,
        videos: videos,
        movieDetails: movieDetails,
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  final List<Video> videos;
  final Movie? movieDetails;
  const _CustomSliverAppBar({
    required this.movie,
    required this.videos,
    required this.movieDetails,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: AppBarNetflix(
            minExtend: kToolbarHeight,
            maxExtend: size.height * 0.45, //0.35
            size: size,
            movie: movie,
            videos: videos,
          ),
        ),
        if (movieDetails != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  ...movieDetails!.genreIds.map(
                    (genre) => Container(
                      padding: const EdgeInsets.all(1),
                      child: Chip(
                        label: Text(genre),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Relleno de contenido para permitir scroll y ver animación
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: List.generate(
                50,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eu erat lacus.',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppBarNetflix extends SliverPersistentHeaderDelegate {
  final double maxExtend;
  final double minExtend;
  final Size size;
  final Movie movie;
  final List<Video> videos;

  const AppBarNetflix({
    required this.maxExtend,
    required this.minExtend,
    required this.size,
    required this.movie,
    required this.videos,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final percent = shrinkOffset / maxExtend;
    //validate the angle at which the card returns
    final uploadLimit = 13 / 100;
    //return value of the card
    final valueBack = (1 - percent - 0.77).clamp(0, uploadLimit);

    final fixRotation = pow(percent, 1.5);

    final card = CoverCard(
      size: size,
      percent: percent,
      uploadLimit: uploadLimit,
      valueBack: valueBack,
      movie: movie,
    );

    final bottomsSliverBar = CustomBottomSliverBar(
      size: size,
      fixRotation: fixRotation,
      percent: percent,
      movie: movie,
    );

    return Stack(
      children: [
        BackgroundSilver(data: movie),
        bottomsSliverBar,
        if (percent > uploadLimit) ...[
          card,
          bottomsSliverBar,
        ] else ...[
          bottomsSliverBar,
          card,
        ],
        videos.isNotEmpty
            ? VideoPlay(
              size: size,
              percent: percent,
              id: movie.id,
              urlImage: movie.posterPath,
              image: movie.posterPath,
              video: videos,
            )
            : SizedBox(),
        FavoriteCircle(size: size, percent: percent, data: movie),
      ],
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => maxExtend;

  @override
  // TODO: implement minExtent
  double get minExtent => minExtend;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
