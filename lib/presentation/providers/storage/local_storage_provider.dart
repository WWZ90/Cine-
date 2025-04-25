import 'package:cinemania/domain/datasources/local_storage_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/infrastructure/datasources/isar_datasource.dart';

final localStorageDatasourceProvider = Provider<LocalStorageDatasource>((ref) {
  return IsarDatasource();
});
