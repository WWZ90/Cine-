import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/infrastructure/repositories/local_storage_repository_impl.dart';

final localStorageRepositoryProvider = Provider((ref) {
  final isar = ref.read(isarDatasourceProvider);
  return LocalStorageRepositoryImpl(datasource: isar);
});