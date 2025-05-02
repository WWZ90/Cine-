import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoTrailer extends ConsumerStatefulWidget {
  final String id;
  final String type;
  const VideoTrailer({required this.id, required this.type, super.key});

  @override
  ConsumerState<VideoTrailer> createState() => _VideoTrailerState();
}

class _VideoTrailerState extends ConsumerState<VideoTrailer> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Video>> videosAsync;
    if (widget.type == 'Movie') {
      videosAsync = ref.watch(videosMovieProvider(widget.id));
    } else {
      videosAsync = ref.watch(videosTVShowProvider(widget.id));
    }
    return videosAsync.when(
      data: (videos) => _VideosList(videos: videos),
      error: (_, __) => const Center(child: Text('No se pudo cargar videos')),
      loading:
          () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _VideosList extends StatelessWidget {
  final List<Video> videos;

  const _VideosList({required this.videos});

  @override
  Widget build(BuildContext context) {
    //* Nada que mostrar
    if (videos.isEmpty) {
      return const SizedBox();
    }

    // Filtrar solo los videos que sean trailers
    final trailers =
        videos.where((video) => video.type == Type.TRAILER).toList();

    // Ordenar por fecha de publicación descendente (más reciente primero)
    trailers.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    // Seleccionar el trailer más reciente, o el primer video si no hay trailers
    final selectedVideo = trailers.isNotEmpty ? trailers.first : videos.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_YouTubeVideoPlayer(youtubeId: selectedVideo.key)],
    );
  }
}

class _YouTubeVideoPlayer extends StatefulWidget {
  final String youtubeId;

  const _YouTubeVideoPlayer({required this.youtubeId});

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {
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
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _controller.pause();
        _controller.dispose();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: YoutubePlayer(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
