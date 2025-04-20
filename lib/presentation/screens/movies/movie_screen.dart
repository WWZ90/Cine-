import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemania/config/helpers/date_format.dart';
import 'package:cinemania/config/helpers/human_formats.dart';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/domain/entities/movie_detail.dart';
import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/presentation/providers/movies/movie_detail_provider.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
        .read(actorsByMovieProvider.notifier)
        .loadActors(widget.movie.id.toString());
    ref
        .read(videosMovieProvider.notifier)
        .loadVideosMovie(widget.movie.id.toString());
    ref
        .read(similarMoviesProvider(widget.movie.id.toString()).notifier)
        .loadNextPage();
    ref
        .read(reviewsByMovieProvider(widget.movie.id.toString()).notifier)
        .loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final MovieDetail? movieDetails =
        ref.watch(movieDetailProvider)[widget.movie.id.toString()];

    final List<Video> videos = ref.watch(videosMovieProvider);

    return Scaffold(
      body:
          movieDetails != null
              ? _CustomSliverAppBar(
                movie: widget.movie,
                videos: videos,
                movieDetails: movieDetails,
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  final List<Video> videos;
  final MovieDetail movieDetails;
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
            maxExtend: size.height * 0.55, //0.35
            size: size,
            movie: movie,
            videos: videos,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        SizedBox(width: 4),
                        Text(formatDate(movieDetails.releaseDate)),
                      ],
                    ),
                    Text(' | '),
                    Row(
                      children: [
                        Icon(Icons.money_off_outlined),
                        SizedBox(width: 4),
                        Text(
                          HumanFormats.number(movieDetails.budget.toDouble()),
                        ),
                      ],
                    ),
                    Text(' | '),
                    Row(
                      children: [
                        Icon(Icons.monetization_on_outlined),
                        SizedBox(width: 4),
                        Text(
                          HumanFormats.number(movieDetails.revenue.toDouble()),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 2,
                  runSpacing: 0,
                  children: [
                    ...movieDetails.genres.map(
                      (genre) => Container(
                        padding: const EdgeInsets.all(1),
                        child: Chip(
                          label: Text(genre.name),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                movieDetails.overview.isNotEmpty
                    ? Column(
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            movieDetails.overview,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    )
                    : SizedBox(height: 15),
                _ReviewsByMovie(movieId: movie.id.toString()),
                SizedBox(height: 20),
                _ActosByMovie(movieId: movie.id.toString()),
                _SimilarMovies(movieId: movie.id.toString()),
              ],
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
  double get maxExtent => maxExtend;

  @override
  double get minExtent => minExtend;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _ActosByMovie extends ConsumerWidget {
  final String movieId;
  const _ActosByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);
    if (actorsByMovie[movieId] == null) {
      return CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = actorsByMovie[movieId]!;
    return SizedBox(
      height: 245,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: EdgeInsets.all(8.0),
            width: 165,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: LoadImage(url: actor.profilePath, w: 170, h: 183),
                ),
                SizedBox(height: 10),
                Text(actor.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  actor.character ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SimilarMovies extends ConsumerWidget {
  final String movieId;
  const _SimilarMovies({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final similarMovies = ref.watch(similarMoviesProvider(movieId));
    if (similarMovies.isEmpty) {
      return CircularProgressIndicator(strokeWidth: 2);
    }
    return MoviesHorizontalListview(
      movies: similarMovies,
      title: 'Similar movies',
      subTitle: 'All time',
      loadNextPage: () {
        ref.read(similarMoviesProvider(movieId).notifier).loadNextPage();
      },
    );
  }
}

class _ReviewsByMovie extends ConsumerStatefulWidget {
  final String movieId;
  const _ReviewsByMovie({required this.movieId});

  @override
  ConsumerState<_ReviewsByMovie> createState() => _ReviewsByMovieState();
}

class _ReviewsByMovieState extends ConsumerState<_ReviewsByMovie> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviews = ref.watch(reviewsByMovieProvider(widget.movieId));
    if (reviews.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.all(10.0),
      height: 300.0,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              clipBehavior: Clip.hardEdge,
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              LoadImage(
                                url: review.authorDetails.avatarPath!,
                                w: 40,
                                h: 40,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (review.authorDetails.name.isNotEmpty)
                                    Text(
                                      review.authorDetails.name,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                    ),
                                  Text(
                                    '@${review.authorDetails.username}',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (review.authorDetails.rating != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    StarsRatingBarWithInfo(
                                      rating:
                                          review.authorDetails.rating! * 0.5,
                                      iconSize: 13,
                                    ),
                                  ],
                                ),
                                Text(
                                  formatDate(review.createdAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 44, 44, 44),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Html(
                                data: review.content,
                                style: {
                                  'body': Style(textAlign: TextAlign.justify),
                                },
                                onLinkTap: (url, _, __) {
                                  debugPrint("Opening $url...");
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          SmoothPageIndicator(
            controller: _pageController,
            count: reviews.length,
            effect: ExpandingDotsEffect(
              dotHeight: 6,
              dotWidth: 6,
              expansionFactor: 2.5,
              dotColor: Colors.grey.shade400,
              activeDotColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
