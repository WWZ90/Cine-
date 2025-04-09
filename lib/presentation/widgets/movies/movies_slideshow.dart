import 'package:cinemania/presentation/widgets/widgets.dart'
    show GradientImageBackground, PreciseRatingBar;
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:like_button/like_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MoviesSlideShow extends StatelessWidget {
  final List<Movie> movies;
  const MoviesSlideShow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.55,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: movies.length,
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(movie.posterPath, fit: BoxFit.cover),
                    GradientImageBackground(),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Izquierda: título y rating
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  PreciseRatingBar(
                                    rating: movie.voteAverage * 5 / 10,
                                    iconSize: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${movie.voteAverage.toStringAsFixed(1)}/10 (${movie.voteCount})',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
            
                          // Derecha: Botón Like
                          LikeButton(
                            size: 30,
                            animationDuration: const Duration(milliseconds: 500),
                            onTap: (isLiked) async {
                              return !isLiked;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          SmoothPageIndicator(
            controller: controller,
            count: movies.length,
            effect: const WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              type: WormType.normal,
              dotColor: Colors.white24,
              activeDotColor: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Image.network(movie.backdropPath);
  }
}
