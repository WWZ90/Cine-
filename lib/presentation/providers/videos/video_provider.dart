import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/videos/video_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videosMovieProvider = StateNotifierProvider<VideosNotifier, List<Video>>((
  ref,
) {
  final videosMovieRepository =
      ref.watch(videoMovieRepositoryProvider).getVideosByMovieId;
  return VideosNotifier(
    getVideosMovie: videosMovieRepository,
  ); // Assuming `movie.videos` is a List<Video>
});

typedef GetVideosMovieCallback = Future<List<Video>> Function(String movieId);

class VideosNotifier extends StateNotifier<List<Video>> {
  GetVideosMovieCallback getVideosMovie;
  VideosNotifier({required this.getVideosMovie}) : super([]);

  Future<void> loadVideosMovie(String movieId) async {
    final videos = await getVideosMovie(movieId);
    state = videos;
  }
}

final videosTVShowProvider =
    StateNotifierProvider<VideosTVShowNotifier, List<Video>>((ref) {
      final videosTVShowRepository =
          ref.watch(videoTVShowRepositoryProvider).getVideosByTVShowId;
      return VideosTVShowNotifier(getVideosTVShow: videosTVShowRepository);
    });

typedef GetVideosTVShowCallback = Future<List<Video>> Function(String tvShowId);

class VideosTVShowNotifier extends StateNotifier<List<Video>> {
  GetVideosTVShowCallback getVideosTVShow;
  VideosTVShowNotifier({required this.getVideosTVShow}) : super([]);

  Future<void> loadVideosTVShow(String tvShowId) async {
    final videos = await getVideosTVShow(tvShowId);
    state = videos;
  }
}
