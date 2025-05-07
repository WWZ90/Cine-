import 'package:cinemania/infrastructure/models/moviedb/movie_moviedb.dart';
import 'package:dio/dio.dart';
import 'package:cinemania/domain/entities/movie_detail.dart';
import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/infrastructure/mappers/movie_detail_mapper.dart';
import 'package:cinemania/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemania/infrastructure/mappers/video_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemania/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemania/infrastructure/models/video/video_response.dart';
import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/datasources/movies_datasource.dart';
import 'package:cinemania/domain/entities/movie.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.movieDBKey, 'language': 'es-ES'},
    ),
  );

  List<Movie> _jsonToMovie(
    Map<String, dynamic> json, {
    String type = 'Movie',
  }) {
    List<Movie> movies;
    if (type == 'Movie') {
      final movieDBResponse = MovieDbResponse.fromJson(json);
      movies =
          movieDBResponse.results
              .where((moviedb) => moviedb.posterPath != '')
              .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
              .toList();
    } else {
      final movieDBResponse = List<MovieMovieDB>.from(
        json["cast"].map((x) => MovieMovieDB.fromJson(x)),
      );
      movies =
          movieDBResponse
              .cast()
              .where((moviedb) => moviedb.posterPath != '')
              .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
              .toList();
    }

    movies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return movies;
  }

  List<Video> _jsonToVideo(Map<String, dynamic> json) {
    final videoResponse = VideoResponse.fromJson(json);
    final List<Video> videos =
        videoResponse.results
            .map((video) => VideoMapper.videoToEntity(video))
            .toList();
    return videos;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/now_playing',
        queryParameters: {'page': page},
      );

      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/upcoming',
        queryParameters: {'page': page},
      );

      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );

      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/top_rated',
        queryParameters: {'page': page},
      );

      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<MovieDetail> getMovieById(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get('/movie/$id', cancelToken: cancelToken);
      if (response.statusCode != 200) {
        throw Exception('Movie with id $id not found');
      }

      final movieDetails = MovieDetailsResponse.fromJson(response.data);

      final MovieDetail movie = MovieDetailMapper.movieDetailsToEntity(
        movieDetails,
      );

      return movie;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Video>> getVideosByMovieId(String id) async {
    try {
      final response = await dio.get('/movie/$id/videos');
      if (response.statusCode != 200) {
        throw Exception('Movie with id $id not found');
      }

      List<Video> videos = _jsonToVideo(response.data);

      if (videos.isEmpty) {
        final responseEn = await dio.get(
          '/movie/$id/videos',
          queryParameters: {'language': 'en-US'},
        );

        if (responseEn.statusCode == 200) {
          videos = _jsonToVideo(responseEn.data);
        }
      }

      return videos;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getSimilar(String id, {int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/$id/similar',
        queryParameters: {'page': page},
      );

      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getMoviesByGenreId(String id, {int page = 1}) async {
    try {
      final response = await dio.get(
        '/discover/movie',
        queryParameters: {'with_genres': id, 'page': page},
      );
      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getMoviesByPersonId(String id) async {
    try {
      final response = await dio.get('/person/$id/movie_credits');

      return _jsonToMovie(response.data, type: 'Cast');
    } catch (e) {
      return [];
    }
  }
}
