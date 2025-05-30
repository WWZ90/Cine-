import 'package:cinemania/domain/entities/entities.dart';

abstract class PersonRepository {
  Future<List<CastPerson>> getCastByMovie(String id);
  Future<List<CastPerson>> getCastByTVShow(String id);
  Future<CreditsData> getCreditsByMovie(String movieId);
  Future<CreditsData> getCreditsByTVShow(String tvShowId);
  Future<Person> getPersonById(String id);
  Future<PersonDetails> getPersonDetails(String id);
  Future<List<Person>> getPersonPopular({int page = 1});
  Future<List<Person>> getPersonTrending({int page = 1});
}
