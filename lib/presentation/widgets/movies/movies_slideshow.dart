import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemania/config/helpers/file_storage.dart';
import 'package:cinemania/presentation/widgets/widgets.dart'
    show GradientImageBackground, StarsRatingBarWithInfo;
import 'package:cinemania/domain/entities/movie.dart';
import 'package:like_button/like_button.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../screens/screens.dart';

class MoviesSlideShow extends StatefulWidget {
  final List<Movie> movies;
  const MoviesSlideShow({super.key, required this.movies});

  @override
  State<MoviesSlideShow> createState() => _MoviesSlideShowState();
}

class _MoviesSlideShowState extends State<MoviesSlideShow> {
  int _currentIndex = 0;
  Timer? _autoPlayTimer;
  Timer? _resumeTimer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.movies.length;
      });
    });
  }

  void _onUserInteractionStart() {
    _autoPlayTimer?.cancel();
    _resumeTimer?.cancel();
  }

  void _onUserInteractionEnd() {
    _resumeTimer = Timer(const Duration(seconds: 5), _startAutoPlay);
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _resumeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movies[_currentIndex];
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.55,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.pushNamed(MovieScreen.name, extra: movie),
              onTapDown: (_) => _onUserInteractionStart(),
              onTapUp: (_) => _onUserInteractionEnd(),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 800),
                transitionBuilder:
                    (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                child: Stack(
                  key: ValueKey(movie.id), // Necesario para animación correcta
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: movie.id,
                      child: Image(
                        image: NetworkToFileImage(
                          url: movie.posterPath,
                          file: LocalImageFileManager.fileFromUrl(
                            movie.posterPath,
                          ),
                          debug: true,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    GradientImageBackground(),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              StarsRatingBarWithInfo(
                                rating: movie.voteAverage,
                                voteCount: movie.voteCount,
                              ),
                            ],
                          ),
                          LikeButton(
                            size: 30,
                            animationDuration: const Duration(
                              milliseconds: 500,
                            ),
                            onTap: (isLiked) async => !isLiked,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Indicador
          SmoothPageIndicator(
            controller: PageController(
              initialPage: _currentIndex,
            ), // dummy controller
            count: widget.movies.length,
            effect: const WormEffect(
              dotHeight: 6,
              dotWidth: 6,
              dotColor: Colors.white24,
              activeDotColor: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
