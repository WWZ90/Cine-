import 'package:cinemania/domain/entities/video.dart';
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
