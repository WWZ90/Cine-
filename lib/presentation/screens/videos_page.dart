// lib/presentation/screens/video_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:cinemania/domain/entities/entities.dart';

class VideosPage extends ConsumerWidget {
  static const name = 'video-screen';
  final List<Video> videos;

  const VideosPage({required this.videos, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final List<Video> videos = ref.watch(videos);

    final typeIcons = {
      Type.TRAILER: Icons.movie_filter,
      Type.TEASER: Icons.theaters,
      Type.FEATURETTE: Icons.local_movies,
      Type.CLIP: Icons.videocam,
      Type.BEHIND_THE_SCENES: Icons.camera,
    };

    final typeColors = {
      Type.TRAILER: Colors.blueAccent,
      Type.TEASER: Colors.purpleAccent,
      Type.FEATURETTE: Colors.teal,
      Type.CLIP: Colors.orange,
      Type.BEHIND_THE_SCENES: Colors.grey,
    };

    final displayOrder = [
      Type.TRAILER,
      Type.TEASER,
      Type.FEATURETTE,
      Type.CLIP,
      Type.BEHIND_THE_SCENES,
    ];

    final groupedVideos = <Type, List<Video>>{};
    for (var type in Type.values) {
      final filtered = videos.where((v) => v.type == type).toList();
      if (filtered.isNotEmpty) {
        groupedVideos[type] = filtered;
      }
    }

    final orderedEntries =
        displayOrder
            .where((type) => groupedVideos.containsKey(type))
            .map((type) => MapEntry(type, groupedVideos[type]!))
            .toList();

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Videos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: orderedEntries.length,
                  itemBuilder: (context, index) {
                    final type = orderedEntries[index].key;
                    final typeVideos = orderedEntries[index].value;
                    final title = typeValues.reverse[type] ?? type.name;
                    final icon = typeIcons[type] ?? Icons.video_library;
                    final color = typeColors[type] ?? Colors.white;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(icon, size: 20, color: color),
                                const SizedBox(width: 8),
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...typeVideos.map(
                            (video) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 500),
                                builder:
                                    (context, value, child) => Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: child,
                                      ),
                                    ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    YoutubePlayer(
                                      controller: YoutubePlayerController(
                                        initialVideoId: video.key,
                                        flags: const YoutubePlayerFlags(
                                          autoPlay: false,
                                          forceHD: true,
                                          enableCaption: false,
                                        ),
                                      ),
                                      showVideoProgressIndicator: true,
                                      progressIndicatorColor: color,
                                      progressColors: ProgressBarColors(
                                        playedColor: color,
                                        handleColor: color.withOpacity(0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Publicado el ${_formatDate(video.publishedAt)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)}. ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return months[month - 1];
  }
}
