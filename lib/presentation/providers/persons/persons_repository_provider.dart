import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/datasources/person_moviedb_datasource.dart';
import 'package:cinemania/infrastructure/repositories/person_repository_impl.dart';

//Inmutable
final personsRepositoryProvider = Provider((ref) {
  return PersonRepositoryImpl(PersonMovieDbDatasource());
});
