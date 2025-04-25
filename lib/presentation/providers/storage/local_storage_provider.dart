import 'package:cinemania/domain/datasources/local_storage_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/datasources/isar_datasource.dart';
import 'package:cinemania/infrastructure/repositories/local_storage_repository_imp.dart';

final localStorageDatasourceProvider = Provider<LocalStorageDatasource>((ref) {
  return IsarDatasource();
});
