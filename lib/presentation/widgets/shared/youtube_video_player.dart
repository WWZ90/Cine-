/*
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
*/

/*
//FUNCIONAL CON IFRAME
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
  late final YoutubePlayerController controller;

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 0) {
      controller.pauseVideo(); // pausa cuando ya no es visible
    }
  }

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController.fromVideoId(
      videoId: widget.youtubeId,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    controller.setFullScreenListener((isFullScreen) async {
      if (!mounted) return;

      Future.delayed(Duration(milliseconds: 200), () {
        if (mounted) {
          ref.read(isFullscreenProvider.notifier).state = isFullScreen;
        }
      });

      final videoData = await controller.videoData;
      final startSeconds = await controller.currentTime;

      final currentTime = await FullscreenYoutubePlayer.launch(
        // ignore: use_build_context_synchronously
        context,
        videoId: videoData.videoId,
        startSeconds: startSeconds,
      );

      if (currentTime != null) {
        controller.seekTo(seconds: currentTime);
      }
    });
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('youtube-player-${widget.youtubeId}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: YoutubePlayer(
        key: ObjectKey(controller),
        aspectRatio: 16 / 9,
        enableFullScreenOnVerticalDrag: false,
        controller: controller,
        keepAlive: true,
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:y_player/y_player.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  final String youtubeId;
  final String videoTitle;

  const YouTubeVideoPlayer({
    required this.youtubeId,
    required this.videoTitle,
    super.key,
  });

  @override
  State<YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  YPlayerController? _controller;
  bool _wasPlayingBeforeHidden = false;
  bool _controllerReady = false;
  bool _playRequested = false;
  bool _isInFullscreen = false;

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (_controller == null) return;

    final status = _controller!.status;
    if (info.visibleFraction == 0 &&
        status == YPlayerStatus.playing &&
        !_isInFullscreen) {
      _controller!.pause();
      _wasPlayingBeforeHidden = true;
    } else if (info.visibleFraction > 0 && _wasPlayingBeforeHidden) {
      _controller!.play();
      _wasPlayingBeforeHidden = false;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl =
        'https://img.youtube.com/vi/${widget.youtubeId}/hqdefault.jpg';

    return VisibilityDetector(
      key: Key('youtube-player-${widget.youtubeId}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Offstage(
              offstage: !_playRequested,
              child: YPlayer(
                youtubeUrl:
                    'https://www.youtube.com/watch?v=${widget.youtubeId}',
                autoPlay: false,
                chooseBestQuality: false,
                onControllerReady: (controller) {
                  _controller = controller;
                  setState(() {
                    _controllerReady = true;
                  });
                },
                onEnterFullScreen: () {
                  _isInFullscreen = true;
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                },
                onExitFullScreen: () {
                  _isInFullscreen = false;
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                },
              ),
            ),

            if (!_playRequested) ...[
              Image.network(thumbnailUrl, fit: BoxFit.cover),
              const ColoredBox(color: Colors.black38),
              Center(
                child:
                    !_controllerReady
                        ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white,)
                        : IconButton(
                          iconSize: 50,
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _playRequested = true;
                            });
                            if (_controllerReady && _controller != null) {
                              _controller!.play();
                            }
                          },
                        ),
              ),
            ],
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
