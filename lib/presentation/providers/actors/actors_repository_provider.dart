import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemania/infrastructure/repositories/actor_repository_impl.dart';

//Inmutable
final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl(ActorMovieDbDatasource());
});
