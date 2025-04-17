import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemania/domain/entities/video.dart';

class VideoPlay extends StatelessWidget {
  final int id;
  final Size size;
  final double percent;
  final List<Video> video;
  final String urlImage;
  final String image;

  const VideoPlay({
    super.key,
    required this.size,
    required this.percent,
    required this.video,
    required this.id,
    required this.urlImage,
    required this.image,
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
                      video,
                      context,
                      id,
                      urlImage,
                      image,
                    ),
                  );
                },
              )
              : Container(),
    );
  }

  Widget _buildVideoWidget(
    List<dynamic> data,
    BuildContext context,
    int id,
    String urlImage,
    String image,
  ) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: const Color.fromARGB(255, 219, 43, 43),
      onPressed: () {
        context.pushNamed('video-screen');
      },
      child: Icon(Icons.play_arrow, size: 25),
    );
  }
}
