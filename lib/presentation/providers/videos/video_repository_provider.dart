import 'package:cinemania/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemania/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videoMovieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviedbDatasource());
});
