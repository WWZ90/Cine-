abstract class LocalStorageRepository {
  Future<void> toggleFavorite(dynamic data, String type);
  Future<bool> isFavorite(int id, String type);
  Future<List<dynamic>> loadFavorites({int limit = 10, int offset = 0});
}