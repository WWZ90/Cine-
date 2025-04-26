import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/presentation/screens/screens.dart';

class VideoPlay extends StatelessWidget {
  final Size size;
  final double percent;
  final List<Video> videos;

  const VideoPlay({
    super.key,
    required this.size,
    required this.percent,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: size.height * 0.15,
      right: 10,
      child:
          percent < 0.28
              ? TweenAnimationBuilder<double>(
                tween:
                    percent < 0.25
                        ? Tween(begin: 1, end: 0)
                        : Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, widget) {
                  return Transform.scale(
                    scale: 1.0 - value,
                    child: _buildVideoWidget(
                      videos,
                      context,
                    ),
                  );
                },
              )
              : Container(),
    );
  }

  Widget _buildVideoWidget(
    List<dynamic> videos,
    BuildContext context,
  ) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: const Color.fromARGB(255, 219, 43, 43),
      onPressed: () {
        context.pushNamed(VideosPage.name, extra: videos);
      },
      child: Icon(Icons.play_arrow, size: 25),
    );
  }
}
