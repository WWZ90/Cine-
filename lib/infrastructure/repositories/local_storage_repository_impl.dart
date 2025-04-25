import 'package:cinemania/domain/datasources/local_storage_datasource.dart';
import 'package:cinemania/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl({required this.datasource});

  @override
  Future<bool> isFavorite(int id, String type) {
    return datasource.isFavorite(id, type);
  }

  @override
  Future<List<dynamic>> loadFavorites({int limit = 10, offset = 0, type = ''}) {
    return datasource.loadFavorites(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavorite(dynamic data, String type) {
    return datasource.toggleFavorite(data, type);
  }
}
