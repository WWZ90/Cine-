import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:cinemania/infrastructure/datasources/isar_datasource.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(datasource: IsarDatasource());
});
