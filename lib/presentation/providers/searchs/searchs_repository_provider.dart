import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/datasources/search_moviedb_datasource.dart';
import 'package:cinemania/infrastructure/repositories/search_repository_impl.dart';

final searchsRepositoryProvider = Provider((ref) {
  return SearchRepositoryImpl(SearchMoviedbDatasource());
});
