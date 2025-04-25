import 'package:cinemania/domain/value_objects/favorite_key.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/datasources/local_storage_datasource.dart';

/// Para consultar si una película está marcada como favorita:
final isFavoriteProvider = FutureProvider.family<bool, FavoriteKey>((
  ref,
  key,
) async {
  final db = ref.read(localStorageDatasourceProvider);
  return db.isFavorite(key.id, key.type);
});
