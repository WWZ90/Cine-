import 'package:cinemania/domain/datasources/tv_show_datasource.dart';
import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/domain/entities/tv_show_details.dart';
import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/domain/repositories/tv_show_repository.dart';

class TvShowRepositoryImpl extends TvShowRepository {
  final TvShowDatasource datasource;

  TvShowRepositoryImpl(this.datasource);

  @override
  Future<List<TVShow>> getAiringToday({int page = 1}) {
    return datasource.getAiringToday();
  }

  @override
  Future<List<TVShow>> getOnTheAir({int page = 1}) {
    return datasource.getOnTheAir(page: page);
  }

  @override
  Future<List<TVShow>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<List<TVShow>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }

  @override
  Future<TvShowDetails> getTVShowById(String id) {
    return datasource.getTVShowById(id);
  }

  @override
  Future<List<Video>> getVideosByTVShowId(String id) {
    return datasource.getVideosByTVShowId(id);
  }
  
  @override
  Future<List<TVShow>> getTVShowByGenreId(String id, {int page = 1}) {
    return datasource.getTVShowByGenreId(id);
  }
}
