import 'package:dio/dio.dart';
import 'package:cinemania/domain/datasources/movies_datasource.dart';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/domain/entities/movie_detail.dart';
import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource;

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return datasource.getUpcoming(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }

  @override
  Future<Movie> getMovieById(String id, {CancelToken? cancelToken}) {
    return datasource.getMovieById(id, cancelToken: cancelToken);
  }

  @override
  Future<MovieDetail> getMovieDetailById(String id, {CancelToken? cancelToken}) {
    return datasource.getMovieDetailById(id, cancelToken: cancelToken);
  }

  @override
  Future<List<Video>> getVideosByMovieId(String id) {
    return datasource.getVideosByMovieId(id);
  }

  @override
  Future<List<Movie>> getSimilar(String id, {int page = 1}) {
    return datasource.getSimilar(id, page: page);
  }

  @override
  Future<List<Movie>> getMoviesByGenreId(String id, {int page = 1}) {
    return datasource.getMoviesByGenreId(id, page: page);
  }

  @override
  Future<List<Movie>> getMoviesByPersonId(String id) {
    return datasource.getMoviesByPersonId(id);
  }

  @override
  Future<Map<String, List<Movie>>> getMoviesCrewByPersonId(String id) {
    return datasource.getMoviesCrewByPersonId(id);
  }
}
