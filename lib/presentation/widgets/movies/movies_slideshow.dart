import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemania/presentation/widgets/widgets.dart'
    show GradientImageBackground, StarsRatingBarWithInfo;
import 'package:flutter/material.dart';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:like_button/like_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MoviesSlideShow extends StatefulWidget {
  final List<Movie> movies;
  const MoviesSlideShow({super.key, required this.movies});

  @override
  State<MoviesSlideShow> createState() => _MoviesSlideShowState();
}

class _MoviesSlideShowState extends State<MoviesSlideShow> {
  late final PageController _controller;
  Timer? _autoPlayTimer;
  Timer? _resumeTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients && widget.movies.isNotEmpty) {
        _currentPage = (_currentPage + 1) % widget.movies.length;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.55,
      child: Column(
        children: [
          Expanded(
            child: Listener(
              onPointerDown: (_) => _onUserInteractionStart(),
              onPointerUp: (_) => _onUserInteractionEnd(),
              child: PageView.builder(
                itemCount: widget.movies.length,
                controller: _controller,
                onPageChanged: (index) => _currentPage = index,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final movie = widget.movies[index];
                  // Precache next image
                  if (index + 1 < widget.movies.length) {
                    precacheImage(
                      NetworkImage(widget.movies[index + 1].posterPath),
                      context,
                    );
                  }
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      FadeIn(
                        duration: Duration(seconds: 2),
                        child: CachedNetworkImage(
                          imageUrl: movie.posterPath,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 200),
                          placeholder: (context, url) {
                            return Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          },
                        ),
                      ),
                      GradientImageBackground(),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                StarsRatingBarWithInfo(movie: movie),
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
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          SmoothPageIndicator(
            controller: _controller,
            count: widget.movies.length,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
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
