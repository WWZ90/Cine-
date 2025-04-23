import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/datasources/genres_datasource.dart';
import 'package:cinemania/domain/entities/genre.dart';
import 'package:cinemania/infrastructure/mappers/genre_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/genres_response.dart';

import 'package:dio/dio.dart';

class GenreMoviedbDatasource extends GenresDatasource {
  final dio = Dio();

  @override
  Future<List<Genre>> getGenresMovie() async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/genre/movie/list',
      queryParameters: {'api_key': Environment.movieDBKey, 'language': 'es-ES'},
    );

    if (response.statusCode != 200) {
      throw Exception('No movie genres found');
    }

    final genreResponse = GenreResponse.fromJson(response.data);

    List<Genre> genres =
        genreResponse.genres
            .map((genre) => GenreMapper.genreToEntity(genre))
            .toList();

    return genres;
  }
  
  @override
  Future<List<Genre>> getGenresTVShow() async {
    final response = await dio.get(
      'https://api.themoviedb.org/3/genre/tv/list',
      queryParameters: {'api_key': Environment.movieDBKey, 'language': 'es-ES'},
    );

    if (response.statusCode != 200) {
      throw Exception('No TV Show genres found');
    }

    final genreResponse = GenreResponse.fromJson(response.data);

    List<Genre> genres =
        genreResponse.genres
            .map((genre) => GenreMapper.genreToEntity(genre))
            .toList();

    return genres;
  }
}