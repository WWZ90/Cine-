import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/presentation/providers/videos/video_repository_provider.dart';

final videosMovieProvider = FutureProvider.family<List<Video>, String>((
  ref,
  movieId,
) async {
  final videosMovieRepository =
      ref.watch(videoMovieRepositoryProvider).getVideosByMovieId;
  final videos = await videosMovieRepository(movieId);
  return videos;
});


final videosTVShowProvider = FutureProvider.family<List<Video>, String>((
  ref,
  tvShowId,
) async {
  final videosTVShowProvider =
      ref.watch(videoTVShowRepositoryProvider).getVideosByTVShowId;
  final videos = await videosTVShowProvider(tvShowId);
  return videos;
});