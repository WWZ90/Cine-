import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:cinemania/presentation/screens/screens.dart';
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
  late PageController _pageController;

  List<dynamic> _displayData = [];
  int _displayDataLength = 0;

  @override
  void initState() {
    super.initState();
    _updateDisplayData();
    _pageController = PageController(initialPage: _currentIndex);
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(TopSlideShow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allData != oldWidget.allData) {
      _updateDisplayData();
      if (_currentIndex >= _displayDataLength && _displayDataLength > 0) {
        _currentIndex = _displayDataLength - 1;
      } else if (_displayDataLength == 0) {
        _currentIndex = 0;
      }
      _autoPlayTimer?.cancel();
      _resumeTimer?.cancel();
      if (_displayData.isNotEmpty) {
        _startAutoPlay();
      }
    }
  }

  void _updateDisplayData() {
    _displayData = widget.allData.take(20).toList();
    _displayDataLength = _displayData.length;
  }

  void _startAutoPlay() {
    if (!mounted || _displayData.isEmpty) return;
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && _displayData.isNotEmpty) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _displayDataLength;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
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

    if (_displayData.isEmpty) {
      return SizedBox(
        height: screenHeight * 0.55,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 1)),
      );
    }

    return VisibilityDetector(
      key: Key('top-slideshow-${widget.type}'),
      onVisibilityChanged: (info) {
        final isVisible = info.visibleFraction > 0.0;
        if (!isVisible) {
          _autoPlayTimer?.cancel();
        } else {
          _startAutoPlay();
        }
      },
      child: SizedBox(
        height: screenHeight * 0.55,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final data = _displayData[_currentIndex];
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
                  itemCount: _displayDataLength,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final data = _displayData[index];
                    String name =
                        widget.type == 'Person' ? data.name : data.title;
                    data.uniqueID =
                        '${data.id}"-${widget.type}-section-top-slideshow-$name';

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      transitionBuilder:
                          (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                      child: Hero(
                        tag: data.uniqueID,
                        child: Stack(
                          key: ValueKey(data.id),
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  widget.type == 'Person'
                                      ? data.profilePath
                                      : data.posterPath,
                              width: MediaQuery.of(context).size.width,
                              placeholder:
                                  (context, url) => const Center(
                                    child: SizedBox(
                                      width: 35,
                                      height: 35,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) =>
                                      const Icon(Icons.error),
                            ),
                            GradientImageBackground(),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.80,
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
                                      StarsRatingBarWithInfo(
                                        rating:
                                            widget.type != 'Person'
                                                ? data.voteAverage
                                                : data.popularity,
                                        voteCount:
                                            widget.type != 'Person'
                                                ? data.voteCount
                                                : 0,
                                        type: widget.type,
                                      ),
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
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            SmoothPageIndicator(
              controller: _pageController,
              count: _displayDataLength,
              effect: const WormEffect(
                dotHeight: 6,
                dotWidth: 6,
                dotColor: Colors.white24,
                activeDotColor: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
