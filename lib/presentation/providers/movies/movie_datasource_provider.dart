import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemania/domain/datasources/movies_datasource.dart';

/// Provee la implementación concreta de MoviesDatasource (TMDB + Isar si hiciese falta).
final moviesDatasourceProvider = Provider<MoviesDatasource>((ref) {
  // Si tu MoviedbDatasource necesitase inyectarle algo, cabría leerlo aquí:
  return MoviedbDatasource();
  // final localDb = ref.read(localStorageRepositoryProvider);
});