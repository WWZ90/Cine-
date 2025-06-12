import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemania/presentation/widgets/shared/portrait_player_page.dart';

class VideoThumbnailPlayer extends ConsumerWidget {
  final String youtubeId;

  const VideoThumbnailPlayer({super.key, required this.youtubeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnailUrl = 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';

    return GestureDetector(
      onTap: () async {
        ref.read(isFullscreenProvider.notifier).state = true;
        await Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    PortraitPlayerPage(youtubeId: youtubeId),

            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,

            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return child;
            },
          ),
        );

        ref.read(isFullscreenProvider.notifier).state = false;
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: thumbnailUrl,
                  width: MediaQuery.of(context).size.width,
                  placeholder:
                      (context, url) => Center(
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: CircularProgressIndicator(strokeWidth: 1),
                        ),
                      ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),

                const Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
