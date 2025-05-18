import 'package:cinemania/config/global_app_state.dart';
import 'package:dio/dio.dart';

import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/datasources/genres_datasource.dart';
import 'package:cinemania/domain/entities/genre.dart';
import 'package:cinemania/infrastructure/mappers/genre_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/genres_response.dart';

class GenreMoviedbDatasource extends GenresDatasource {
  final Dio dio = Dio();

  GenreMoviedbDatasource();

  void _updateLanguage() {
    dio.options.queryParameters['language'] = GlobalAppState.languageCode;
  }

  @override
  Future<List<Genre>> getGenresMovie() async {
    try {
      _updateLanguage();
      final response = await dio.get(
        'https://api.themoviedb.org/3/genre/movie/list',
        queryParameters: {'api_key': Environment.movieDBKey},
      );

      if (response.statusCode != 200) {
        throw Exception('No movie genres found');
      }

      final genreResponse = GenreResponse.fromJson(response.data);

      return genreResponse.genres
          .map((genre) => GenreMapper.genreToEntity(genre, locale: GlobalAppState.currentLocale.toString()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Genre>> getGenresTVShow() async {
    try {
      _updateLanguage();
      final response = await dio.get(
        'https://api.themoviedb.org/3/genre/tv/list',
        queryParameters: {
          'api_key': Environment.movieDBKey,
          'language': GlobalAppState.languageCode,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('No TV Show genres found');
      }

      final genreResponse = GenreResponse.fromJson(response.data);

      return genreResponse.genres
          .map((genre) => GenreMapper.genreToEntity(genre, locale: GlobalAppState.currentLocale.toString()))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
