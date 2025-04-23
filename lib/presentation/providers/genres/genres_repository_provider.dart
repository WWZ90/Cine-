import 'package:cinemania/infrastructure/datasources/genre_moviedb_datasource.dart';
import 'package:cinemania/infrastructure/repositories/genre_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final genresMoviesRepositoryProvider = Provider((ref) {
  return GenreRepositoryImpl(GenreMoviedbDatasource());
});

final genresTVShowRepositoryProvider = Provider((ref) {
  return GenreRepositoryImpl(GenreMoviedbDatasource());
});
