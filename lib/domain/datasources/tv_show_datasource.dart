import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/domain/entities/tv_show_details.dart';
import 'package:cinemania/domain/entities/video.dart';

abstract class TvShowDatasource {
  Future<List<TVShow>> getAiringToday({int page = 1});
  Future<List<TVShow>> getOnTheAir({int page = 1});
  Future<List<TVShow>> getPopular({int page = 1});
  Future<List<TVShow>> getTopRated({int page = 1});
  Future<TvShowDetails> getTVShowById(String id);
  Future<List<Video>> getVideosByTVShowId(String id);
}
