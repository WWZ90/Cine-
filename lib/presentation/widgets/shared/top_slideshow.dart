import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/config/helpers/file_storage.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class TopSlideShow extends ConsumerStatefulWidget {
  final List<dynamic> allData;
  final String type; // Movie - TVShow - Person
  const TopSlideShow({super.key, required this.allData, required this.type});

  @override
  ConsumerState<TopSlideShow> createState() => _TopSlideShowState();
}

class _TopSlideShowState extends ConsumerState<TopSlideShow> {
  int _currentIndex = 0;
  Timer? _autoPlayTimer;
  Timer? _resumeTimer;
  late PageController _pageController; // Controlador para manejar el scroll

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _startAutoPlay();
  }

  // Comenzar el auto-play
  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % widget.allData.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
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
    _pageController.dispose();
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
            child: GestureDetector(
              onTap: () {
                final data = widget.allData[_currentIndex];
                if (widget.type == 'Movie') {
                  context.pushNamed(MovieScreen.name, extra: data);
                } else if (widget.type == 'TVShow') {
                  context.pushNamed(TVShowScreen.name, extra: data);
                } else {
                  context.pushNamed(PersonScreen.name, extra: data);
                }
              },
              onTapDown: (_) => _onUserInteractionStart(),
              onTapUp: (_) => _onUserInteractionEnd(),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.allData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = widget.allData[index];
                  data.uniqueID =
                      '${data.id}"-${widget.type}-section-${widget.type == 'Person' ? data.name : data.title}';

                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 800),
                    transitionBuilder:
                        (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                    child: Stack(
                      key: ValueKey(data.id),
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: data.uniqueID,
                          child: Image(
                            image: NetworkToFileImage(
                              url:
                                  widget.type == 'Person'
                                      ? data.profilePath
                                      : data.posterPath,
                              file: LocalImageFileManager.fileFromUrl(
                                widget.type == 'Person'
                                    ? data.profilePath
                                    : data.posterPath,
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        GradientImageBackground(),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Ajustar el texto para que se recorte antes del corazón
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.80, // Ajuste aquí el ancho
                                    child: Text(
                                      widget.type == 'Person'
                                          ? data.name
                                          : data.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  widget.type != 'Person'
                                      ? StarsRatingBarWithInfo(
                                        rating: data.voteAverage,
                                        voteCount: data.voteCount,
                                      )
                                      : Text('Popularidad: ${data.popularity}'),
                                ],
                              ),
                              FavLikeButtonConsumer(
                                data: data,
                                type: widget.type,
                                iconSize: 40,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Indicador
          SmoothPageIndicator(
            controller: _pageController,
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
