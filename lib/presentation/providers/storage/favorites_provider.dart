import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/config/helpers/ask_for_review_if_needed.dart';
import 'package:cinemania/domain/repositories/local_storage_repository.dart';

final favoritesProvider =
    StateNotifierProvider<StorageNotifier, Map<int, dynamic>>((ref) {
      final localStorageRepository = ref.watch(localStorageRepositoryProvider);
      return StorageNotifier(localStorageRepository: localStorageRepository);
    });

class StorageNotifier extends StateNotifier<Map<int, dynamic>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageNotifier({required this.localStorageRepository}) : super({});

  Future<List<dynamic>> loadNextPage() async {
    final allData = await localStorageRepository.loadFavorites(
      offset: page * 10,
    );
    page++;

    final tempDataMap = <int, dynamic>{};
    for (final data in allData) {
      tempDataMap[data.id] = data;
    }

    state = {...state, ...tempDataMap};

    return allData;
  }

  Future<void> toggleFavorite(dynamic data) async {
    if (data is Movie) {
      await localStorageRepository.toggleFavorite(data, 'Movie');
    } else if (data is TVShow) {
      await localStorageRepository.toggleFavorite(data, 'TVShow');
    } else {
      await localStorageRepository.toggleFavorite(data, 'Person');
    }

    final bool isInFavorites = state[data.id] != null;

    if (isInFavorites) {
      state.remove(data.id);
      state = {...state};
    } else {
      state = {...state, data.id: data};
      if (state.length == 2) {
        await ReviewFlags.markTwoFavorites();
      }
    }
  }
}
