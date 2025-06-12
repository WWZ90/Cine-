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

      if (mounted) {
        ref.read(isFullscreenProvider.notifier).state = isFullScreen;
      }

      final videoData = await controller.videoData;
      final startSeconds = await controller.currentTime;

      final currentTime = await FullscreenYoutubePlayer.launch(
        // ignore: use_build_context_synchronously
        context,
        videoId: videoData.videoId,
        startSeconds: startSeconds,
      );

      ref.read(isFullscreenProvider.notifier).state = false;
      if (currentTime != null) {
        controller.seekTo(seconds: currentTime);
        controller.pauseVideo();
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

/*
// ACTUAL

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
  bool _isDisposed = false;

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (!mounted || _controller == null || _isDisposed) return;

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
    _isDisposed = true;
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
                        ? const CircularProgressIndicator(strokeWidth: 1, color: Colors.white,)
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
*/

/*
// NUEVO YPLAYER - TESTING

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
  bool _isControllerCallbackCompleted = false;
  bool _playRequestedAndPlayerVisible = false;
  bool _isInFullscreen = false;
  bool _initializationError = false;
  YPlayerStatus _currentPlayerStatus = YPlayerStatus.initial;
  UniqueKey _yPlayerWidgetKey = UniqueKey();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (!mounted ||
        _isDisposed ||
        _controller == null ||
        _initializationError) {
      return;
    }

    YPlayerStatus currentStatus;
    try {
      // Asumiendo que YPlayerController no tiene una propiedad 'isDisposed' explícita.
      // Si la tuviera, la verificaríamos aquí.
      // La verificación principal es '_isDisposed' de nuestro propio estado.
      currentStatus = _controller!.status;
    } catch (e) {
      // print("YPlayer (${widget.youtubeId}): VisibilityChanged - Error getting controller status: $e");
      return;
    }

    if (info.visibleFraction == 0 &&
        currentStatus == YPlayerStatus.playing &&
        !_isInFullscreen) {
      _wasPlayingBeforeHidden = true;
      try {
        _controller!.pause();
      } catch (e) {
        // print("YPlayer (${widget.youtubeId}): VisibilityChanged - Error during pause: $e");
      }
    } else if (info.visibleFraction > 0 &&
        _wasPlayingBeforeHidden &&
        _playRequestedAndPlayerVisible &&
        !_isInFullscreen) {
      _wasPlayingBeforeHidden = false;
      try {
        _controller!.play();
      } catch (e) {
        // print("YPlayer (${widget.youtubeId}): VisibilityChanged - Error during play: $e");
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    try {
      _controller?.dispose();
    } catch (e) {
      // print("YPlayer (${widget.youtubeId}): Error during _controller.dispose(): $e");
    }
    _controller = null;

    if (_isInFullscreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  Future<void> _attemptPlay() async {
    if (!mounted ||
        _isDisposed ||
        _controller == null ||
        !_isControllerCallbackCompleted)
      return;

    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted || _isDisposed || _controller == null) return;

    _currentPlayerStatus = _controller!.status;

    if (_currentPlayerStatus == YPlayerStatus.error) {
      if (mounted && !_isDisposed) {
        setState(() {
          _initializationError = true;
          _playRequestedAndPlayerVisible = false;
        });
      }
      return;
    }

    if (_currentPlayerStatus == YPlayerStatus.playing ||
        _currentPlayerStatus == YPlayerStatus.loading) {
      return;
    }

    try {
      _controller!.play();
      // Después de play, actualiza el estado si es necesario o espera a que el player lo haga.
      // Por ahora, no hacemos setState aquí para evitar bucles si el plugin ya actualiza.
    } catch (e) {
      if (mounted && !_isDisposed) {
        setState(() {
          _initializationError = true;
          _playRequestedAndPlayerVisible = false;
        });
      }
    }
  }

  void _resetAndRetry() {
    if (!mounted || _isDisposed) return;
    setState(() {
      _initializationError = false;
      _playRequestedAndPlayerVisible = false;
      _isControllerCallbackCompleted = false;
      // No es necesario disponer _controller aquí si la key de YPlayer cambia,
      // ya que el framework se encargará de disponer el widget YPlayer antiguo.
      _controller = null;
      _currentPlayerStatus = YPlayerStatus.initial;
      _yPlayerWidgetKey = UniqueKey(); // Forzar recreación de YPlayer
    });
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl =
        'https://img.youtube.com/vi/${widget.youtubeId}/hqdefault.jpg';

    return VisibilityDetector(
      key: Key(
        'youtube-player-visibility-${widget.youtubeId}-${_yPlayerWidgetKey.toString()}',
      ),
      onVisibilityChanged: _handleVisibilityChanged,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Offstage(
              offstage: !_playRequestedAndPlayerVisible,
              child: YPlayer(
                key: _yPlayerWidgetKey,
                youtubeUrl:
                    'https://www.youtube.com/watch?v=${widget.youtubeId}',
                autoPlay: false,
                aspectRatio: 16 / 9,
                onControllerReady: (controller) {
                  if (!mounted || _isDisposed) {
                    // print("YPlayer (${widget.youtubeId}): onControllerReady but widget is disposed/unmounted. Disposing new controller.");
                    try {
                      controller.dispose();
                    } catch (e) {
                      // print("YPlayer (${widget.youtubeId}): Error disposing controller in onControllerReady after widget dispose: $e");
                    }
                    return;
                  }

                  if (_controller != controller) {
                    _controller?.dispose();
                    _controller = controller;
                  }

                  _isControllerCallbackCompleted = true;
                  _currentPlayerStatus = _controller!.status;

                  if (_currentPlayerStatus == YPlayerStatus.error) {
                    if (mounted && !_isDisposed) {
                      // Doble check por si acaso
                      setState(() {
                        _initializationError = true;
                        _playRequestedAndPlayerVisible = false;
                      });
                    }
                    return;
                  }

                  if (_playRequestedAndPlayerVisible && !_initializationError) {
                    _attemptPlay();
                  } else if (mounted && !_isDisposed) {
                    setState(
                      () {},
                    ); // Para actualizar UI si el botón de play dependía de _isControllerCallbackCompleted
                  }
                },
                onEnterFullScreen: () {
                  if (!mounted || _isDisposed) return;
                  if (mounted && !_isDisposed) {
                    // Doble check
                    setState(() {
                      _isInFullscreen = true;
                    });
                  }
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                },
                onExitFullScreen: () {
                  if (!mounted || _isDisposed) return;
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                  if (mounted && !_isDisposed) {
                    // Doble check
                    setState(() {
                      _isInFullscreen = false;
                    });
                  }
                },
              ),
            ),

            if (!_playRequestedAndPlayerVisible || _initializationError)
              Positioned.fill(
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      if (!_initializationError)
                        Image.network(
                          thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey.shade700,
                                size: 40,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                strokeWidth: 2,
                                color: Colors.white54,
                              ),
                            );
                          },
                        ),
                      if (!_initializationError)
                        const ColoredBox(color: Colors.black38),

                      if (_initializationError)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade300,
                                size: 30,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Error al cargar video", // TODO: Localizar
                                style: TextStyle(
                                  color: Colors.red.shade300,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text(
                                  "Reintentar",
                                  style: TextStyle(fontSize: 13),
                                ), // TODO: Localizar
                                onPressed: _resetAndRetry,
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white70,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.1,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        (_playRequestedAndPlayerVisible &&
                                !_isControllerCallbackCompleted)
                            ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                            : IconButton(
                              iconSize: 50, // O 60 si prefieres más grande
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ), // O play_circle_outline
                              onPressed: () {
                                if (!mounted || _isDisposed) return;
                                setState(() {
                                  _playRequestedAndPlayerVisible = true;
                                  _initializationError = false;
                                });
                                if (_isControllerCallbackCompleted &&
                                    _controller != null) {
                                  _attemptPlay();
                                }
                              },
                            ),
                    ],
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cinemania/presentation/providers/providers.dart';

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
            constraints: BoxConstraints(maxWidth: screenWidth * 0.95),
            child: AspectRatio(aspectRatio: 16 / 9, child: player),
          ),
        );
      },
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_web_player/youtube_web_player.dart';

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
  YoutubeWebPlayerController? _controller;
  @override
  void initState() {
    _controller = YoutubeWebPlayerController();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 0) {
      _controller?.pause(); // pausa cuando ya no es visible
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('youtube-player-${widget.youtubeId}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubeWebPlayer(
          videoId: widget.youtubeId,
          isIframeAllowFullscreen: false,
          isAllowsInlineMediaPlayback: false,
          controller: _controller,
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teqani_youtube_player/teqani_youtube_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:splayer/splayer.dart';
import 'package:youtube_player_flutter_plus/youtube_player_flutter_plus.dart';

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
  @override
  Widget build(BuildContext context) {
    final playerConfig = PlayerConfig(
      videoId: widget.youtubeId, // Your YouTube video ID
      autoPlay: true,
      showControls: true,
      fullscreenByDefault: false,
      allowFullscreen: true,
      muted: false,
      loop: false,
      playbackRate: 1.0,
      enableCaption: true,
      enableJsApi: true,
      showRelatedVideos: false,
      startAt: 30, // Start at 30 seconds
      endAt: 120, // End at 2 minutes
      enableHardwareAcceleration: true,
      volume: 0.8,
      styleOptions: YouTubeStyleOptions(
        showPlayButton: true,
        showVolumeControls: true,
        showProgressBar: true,
        showFullscreenButton: true,
      ),
    );
    final thumbnailUrl =
        'https://img.youtube.com/vi/${widget.youtubeId}/hqdefault.jpg';
    return TeqaniYoutubePlayer(
      controller: TeqaniYoutubePlayerController(
        initialConfig: playerConfig,
        onReady: () => print('Player is ready'),
        onStateChanged: (state) => print('Player state: $state'),
      ),
      aspectRatio: 16 / 9,
    );
  }
}
*/