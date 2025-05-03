import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod_player/pod_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class YouTubeVideoPlayer extends ConsumerStatefulWidget {
  final String youtubeId;
  final String videoTitle;

  const YouTubeVideoPlayer({
    required this.youtubeId,
    required this.videoTitle,
    super.key,
  });

  @override
  ConsumerState<YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends ConsumerState<YouTubeVideoPlayer> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(
        'https://youtu.be/${widget.youtubeId}',
      ),
      podPlayerConfig: const PodPlayerConfig(autoPlay: false, isLooping: false),
    )..initialise();
    super.initState();
  }

  Future<void> _handleFullScreenToggle(bool isFullScreen) async {
    ref.read(isFullscreenProvider.notifier).state = isFullScreen;

    if (isFullScreen) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 0) {
      controller.pause(); // pausa cuando ya no es visible
    }
  }

  @override
  void dispose() {
    controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl =
        'https://img.youtube.com/vi/${widget.youtubeId}/hqdefault.jpg';

    return VisibilityDetector(
      key: Key('youtube-player-${widget.youtubeId}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            PodVideoPlayer(
              controller: controller,
              onToggleFullScreen: _handleFullScreenToggle,
              videoThumbnail: DecorationImage(
                image: NetworkImage(thumbnailUrl),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.videoTitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cinemania/presentation/providers/providers.dart';

class YouTubeVideoPlayer extends ConsumerStatefulWidget {
  final String youtubeId;

  const YouTubeVideoPlayer({required this.youtubeId, super.key});

  @override
  ConsumerState<YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends ConsumerState<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
        useHybridComposition: false,
      ),
    );

    _controller.addListener(() async {
      final isFullscreen = _controller.value.isFullScreen;

      ref.read(isFullscreenProvider.notifier).state = isFullscreen;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.95,
            ),
            child: AspectRatio(aspectRatio: 16 / 9, child: player),
          ),
        );
      },
    );
  }
}
*/