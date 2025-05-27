import 'package:dio/dio.dart';
import 'package:cinemania/domain/entities/entities.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
  Future<Movie> getMovieById(String id, {CancelToken? cancelToken});
  Future<MovieDetail> getMovieDetailById(String id, {CancelToken? cancelToken});
  Future<List<Video>> getVideosByMovieId(String id);
  Future<List<Movie>> getSimilar(String id, {int page = 1});
  Future<List<Movie>> getMoviesByGenreId(String id, {int page = 1});
  Future<List<Movie>> getMoviesByPersonId(String id);
}
