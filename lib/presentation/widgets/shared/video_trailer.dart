import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/presentation/widgets/shared/youtube_video_player.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';

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
      error: (_, __) => Center(child: Text(AppLocalizations.of(context)!.unableToLoadVideos)),
      loading:
          () => const Center(child: CircularProgressIndicator(strokeWidth: 1)),
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
      children: [YouTubeVideoPlayer(youtubeId: selectedVideo.key, videoTitle: selectedVideo.name,)],
    );
  }
}

