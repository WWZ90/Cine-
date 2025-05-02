import 'package:cinemania/domain/entities/entities.dart';

abstract class ActorsDatasource {
  Future<List<Actor>> getActorsByMovie(String id);
  Future<List<Actor>> getActorsByTVShow(String id);
}
