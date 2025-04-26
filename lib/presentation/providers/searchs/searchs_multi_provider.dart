import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/searchs/searchs_repository_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedProvider =
    StateNotifierProvider<SearchedNotifier, List<MultiSearch>>((ref) {
      final searchRepository = ref.read(searchsRepositoryProvider);
      return SearchedNotifier(
        ref: ref,
        multiSearch: searchRepository.multiSearch,
      );
    });

typedef SearchCallback = Future<List<MultiSearch>> Function(String query);

class SearchedNotifier extends StateNotifier<List<MultiSearch>> {
  final Ref ref;
  final SearchCallback multiSearch;
  SearchedNotifier({required this.ref, required this.multiSearch}) : super([]);

  Future<List<MultiSearch>> searchByQuery(String query) async {
    ref.read(searchQueryProvider.notifier).update((state) => query);

    final List<MultiSearch> searchs = await multiSearch(query);

    state = searchs;

    return searchs;
  }
}
