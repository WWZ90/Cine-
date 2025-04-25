abstract class LocalStorageDatasource {
  Future<void> toggleFavorite(dynamic data, String type);
  Future<bool> isFavorite(int id, String type);
  Future<List<dynamic>> loadFavorites({int limit = 10, offset = 0, String type});
}
