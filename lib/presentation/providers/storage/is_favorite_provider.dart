import 'package:cinemania/domain/value_objects/favorite_key.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Para consultar si una película está marcada como favorita:
final isFavoriteProvider = FutureProvider.family<bool, FavoriteKey>((
  ref,
  key,
) async {
  final db = ref.read(localStorageRepositoryProvider);
  return db.isFavorite(key.id, key.type);
});
