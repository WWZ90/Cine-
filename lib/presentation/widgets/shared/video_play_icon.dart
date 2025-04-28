import 'package:animate_do/animate_do.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/presentation/screens/screens.dart';

class VideoPlayIcon extends ConsumerStatefulWidget {
  final Size size;
  final double percent;
  final dynamic data;
  final String type;

  const VideoPlayIcon({
    super.key,
    required this.size,
    required this.percent,
    required this.type,
    required this.data,
  });

  @override
  ConsumerState<VideoPlayIcon> createState() => _VideoPlayState();
}

class _VideoPlayState extends ConsumerState<VideoPlayIcon> {
  @override
  Widget build(BuildContext context) {
    // Usamos ConsumerState para acceder al estado
    AsyncValue<List<Video>> videosAsync;
    if (widget.data is Movie) {
      videosAsync = ref.watch(videosMovieProvider(widget.data.id.toString()));
    } else {
      videosAsync = ref.watch(videosTVShowProvider(widget.data.id.toString()));
    }

    return videosAsync.when(
      data: (videos) {
        if (videos.isNotEmpty) {
          return Positioned(
            bottom: widget.size.height * 0.15,
            right: 10,
            child:
                widget.percent < 0.28
                    ? TweenAnimationBuilder<double>(
                      tween:
                          widget.percent < 0.25
                              ? Tween(begin: 1, end: 0)
                              : Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, widget) {
                        return Transform.scale(
                          scale: 1.0 - value,
                          child: _buildVideoWidget(videos, context),
                        );
                      },
                    )
                    : Container(),
          );
        } else {
          return SizedBox();
        }
      },
      loading:
          () => SizedBox(), // Mientras se cargan los videos no se muestra nada
      error: (error, stack) => SizedBox(),
    );
  }

  Widget _buildVideoWidget(List<Video> videos, BuildContext context) {
    return FadeIn(
      duration: Duration(milliseconds: 200),
      child: FloatingActionButton(
        mini: true,
        backgroundColor: const Color.fromARGB(255, 219, 43, 43),
        onPressed: () {
          widget.type == 'Movie'
              ? context.pushNamed('movie-video-screen', extra: videos)
              : context.pushNamed('tv-show-video-screen', extra: videos);
        },
        child: Icon(Icons.play_arrow, size: 25),
      ),
    );
  }
}
