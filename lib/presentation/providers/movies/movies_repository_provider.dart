import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemania/infrastructure/repositories/movie_repository_impl.dart';

//Inmutable
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviedbDatasource());
});
