import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/domain/entities/movie_detail.dart';
import 'package:cinemania/domain/entities/review.dart';
import 'package:cinemania/domain/entities/video.dart';
import 'package:dio/dio.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
  Future<MovieDetail> getMovieById(String id, {CancelToken? cancelToken});
  Future<List<Video>> getVideosByMovieId(String id);
  Future<List<Movie>> getSimilar(String id, {int page = 1});
  Future<List<Movie>> getMoviesByGenreId(String id, {int page = 1});
}
