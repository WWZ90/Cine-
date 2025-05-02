import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/datasources/actors_datasource.dart';
import 'package:cinemania/domain/entities/actor.dart';
import 'package:cinemania/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.movieDBKey, 'language': 'es-ES'},
    ),
  );

  @override
  Future<List<Actor>> getActorsByMovie(String id) async {
    try {
      final response = await dio.get('/movie/$id/credits');

      if (response.statusCode != 200) {
        throw Exception('Actors for movieId $id not found');
      }

      final castResponse = CreditsResponse.fromJson(response.data);

      List<Actor> actors =
          castResponse.cast
              .map((cast) => ActorMapper.castToEntity(cast))
              .toList();

      return actors;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Actor>> getActorsByTVShow(String id) async {
    try {
      final response = await dio.get('/tv/$id/credits');

      if (response.statusCode != 200) {
        throw Exception('Actors for tvShowId $id not found');
      }

      final castResponse = CreditsResponse.fromJson(response.data);
      List<Actor> actors =
          castResponse.cast
              .map((cast) => ActorMapper.castToEntity(cast))
              .toList();

      return actors;
    } catch (e) {
      return [];
    }
  }
}
