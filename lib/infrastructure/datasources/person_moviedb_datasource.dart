import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/datasources/persons_datasource.dart';
import 'package:cinemania/domain/entities/cast_person.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/domain/entities/person_details.dart';
import 'package:cinemania/infrastructure/mappers/person_details_mapper.dart';
import 'package:cinemania/infrastructure/mappers/cast_mapper.dart';
import 'package:cinemania/infrastructure/mappers/person_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/credits_response.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_details_response.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_response.dart';
import 'package:dio/dio.dart';

class PersonMovieDbDatasource extends PersonDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.movieDBKey, 'language': 'es-ES'},
    ),
  );

  @override
  Future<List<CastPerson>> getCastByMovie(String id) async {
    try {
      final response = await dio.get('/movie/$id/credits');

      if (response.statusCode != 200) {
        throw Exception('Actors for movieId $id not found');
      }

      final castResponse = CreditsResponse.fromJson(response.data);

      List<CastPerson> actors =
          castResponse.cast
              .map((cast) => CastMapper.castToEntity(cast))
              .toList();

      return actors;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<CastPerson>> getCastByTVShow(String id) async {
    try {
      final response = await dio.get('/tv/$id/credits');

      if (response.statusCode != 200) {
        throw Exception('Actors for tvShowId $id not found');
      }

      final castResponse = CreditsResponse.fromJson(response.data);
      List<CastPerson> actors =
          castResponse.cast
              .map((cast) => CastMapper.castToEntity(cast))
              .toList();

      return actors;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<PersonDetails> getPersonDetails(String id) async {
    try {
      final response = await dio.get('/person/$id');
      if (response.statusCode != 200) {
        throw Exception('No person with id $id found');
      }

      final personResponse = PersonDetailsResponse.fromJson(response.data);
      PersonDetails person = PersonDetailsMapper.personDetailsToEntity(
        personResponse,
      );
      return person;
    } catch (e) {
      throw Exception('Failed to fetch person details for id $id');
    }
  }

  @override
  Future<List<Person>> getPersonTrending({int page = 1}) async {
    try {
      final response = await dio.get(
        '/trending/person/day',
        queryParameters: {'page': page},
      );
      if (response.statusCode != 200) {
        throw Exception('An error occours');
      }

      final personResponse = PersonResponse.fromJson(response.data);

      List<Person> persons =
          personResponse.results
              .where((p) => p.profilePath != '')
              .where(
                (person) =>
                    person.knownForDepartment == KnownForDepartment.ACTING,
              )
              .map((p) => PersonMapper.personToEntity(p))
              .toList();

      return persons;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Person>> getPersonPopular({int page = 1}) async {
    try {
      final response = await dio.get('/person/popular', queryParameters: {'page': page},);

      final personResponse = PersonResponse.fromJson(response.data);

      List<Person> persons =
          personResponse.results
              .where((person) => person.profilePath != '')
              .where(
                (person) =>
                    person.knownForDepartment == KnownForDepartment.ACTING,
              )
              .map((person) => PersonMapper.personToEntity(person))
              .toList();
      return persons;
    } catch (e) {
      return [];
    }
  }
}
