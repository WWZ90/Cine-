import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/domain/datasources/persons_datasource.dart';
import 'package:cinemania/domain/repositories/persons_repository.dart';

class PersonRepositoryImpl extends PersonRepository {
  final PersonDatasource datasource;

  PersonRepositoryImpl(this.datasource);

  @override
  Future<List<CastPerson>> getCastByMovie(String id) {
    return datasource.getCastByMovie(id);
  }

  @override
  Future<List<CastPerson>> getCastByTVShow(String id) {
    return datasource.getCastByTVShow(id);
  }

  @override
  Future<Person> getPersonById(String id) {
    return datasource.getPersonById(id);
  }

  @override
  Future<PersonDetails> getPersonDetails(String id) {
    return datasource.getPersonDetails(id);
  }

  @override
  Future<List<Person>> getPersonTrending({int page = 1}) {
    return datasource.getPersonTrending(page: page);
  }

  @override
  Future<List<Person>> getPersonPopular({int page = 1}) {
    return datasource.getPersonPopular(page: page);
  }

  @override
  Future<CreditsData> getCreditsByMovie(String movieId) {
    return datasource.getCreditsByMovie(movieId);
  }

  @override
  Future<CreditsData> getCreditsByTVShow(String tvShowId) {
    return datasource.getCreditsByTVShow(tvShowId);
  }
}
