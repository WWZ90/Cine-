import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/datasources/tv_show_moviedb_datasource.dart';
import 'package:cinemania/infrastructure/repositories/tv_show_repository_impl.dart';

final tvShowRepositoryProvider = Provider((ref) {
  return TvShowRepositoryImpl(TvShowMoviedbDatasource());
});
