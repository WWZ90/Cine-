import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/screens/tv_shows/tv_show_screen.dart';
import 'package:cinemania/presentation/widgets/shared/fav_like_button_consumer.dart';
import 'package:cinemania/config/helpers/file_storage.dart';
import 'package:cinemania/presentation/widgets/widgets.dart'
    show GradientImageBackground, StarsRatingBarWithInfo;

class TopSlideShow extends ConsumerStatefulWidget {
  final List<dynamic> allData;
  final String type; //Movie - TVShow - Person
  const TopSlideShow({super.key, required this.allData, required this.type});

  @override
  ConsumerState<TopSlideShow> createState() => _TopSlideShowState();
}

class _TopSlideShowState extends ConsumerState<TopSlideShow> {
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
        _currentIndex = (_currentIndex + 1) % widget.allData.length;
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
    final data = widget.allData[_currentIndex];
    data.uniqueID = '${data.id}"-${widget.type}-section-${data.title}';
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.55,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.type == 'Movie') {
                  context.pushNamed(MovieScreen.name, extra: data);
                }
                if (widget.type == 'TVShow') {
                  context.pushNamed(TVShowScreen.name, extra: data);
                }
              },
              onTapDown: (_) => _onUserInteractionStart(),
              onTapUp: (_) => _onUserInteractionEnd(),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 800),
                transitionBuilder:
                    (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                child: Stack(
                  key: ValueKey(data.id), // Necesario para animación correcta
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: data.uniqueID,
                      child: Image(
                        image: NetworkToFileImage(
                          url: data.posterPath,
                          file: LocalImageFileManager.fileFromUrl(
                            data.posterPath,
                          ),
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
                                data.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              StarsRatingBarWithInfo(
                                rating: data.voteAverage,
                                voteCount: data.voteCount,
                              ),
                            ],
                          ),
                          FavLikeButtonConsumer(data: data, type: widget.type),
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
            count: widget.allData.length,
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
