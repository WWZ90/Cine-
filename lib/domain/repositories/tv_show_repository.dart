import 'package:cinemania/domain/entities/entities.dart';

abstract class TvShowRepository {
  Future<List<TVShow>> getAiringToday({int page = 1});
  Future<List<TVShow>> getOnTheAir({int page = 1});
  Future<List<TVShow>> getPopular({int page = 1});
  Future<List<TVShow>> getTopRated({int page = 1});
  Future<TvShowDetails> getTVShowById(String id);
  Future<List<Video>> getVideosByTVShowId(String id);
  Future<List<TVShow>> getTVShowByGenreId(String id, {int page = 1});
  Future<List<TVShow>> getSimilar(String id, {int page = 1});
  Future<List<TVShow>> getTVShowByPersonId(String id);
}
