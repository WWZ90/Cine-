import 'package:cinemania/domain/datasources/actors_datasource.dart';
import 'package:cinemania/domain/entities/actor.dart';
import 'package:cinemania/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  final ActorsDatasource datasource;

  ActorRepositoryImpl(this.datasource);

  @override
  Future<List<Actor>> getActorsByMovie(String id) {
    return datasource.getActorsByMovie(id);
  }

  @override
  Future<List<Actor>> getActorsByTVShow(String id) {
    return datasource.getActorsByTVShow(id);
  }
}
