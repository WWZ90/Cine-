import 'package:cinemania/domain/entities/search.dart';
import 'package:cinemania/presentation/providers/searchs/searchs_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
final searchsProvider =
    StateNotifierProvider<SearchNotifier, List<MultiSearch>>((ref) {
      final getSearchs = ref.watch(searchsRepositoryProvider).multiSearch;
      return SearchNotifier(getSearch: getSearchs);
    });

final searchQueryProvider = StateProvider<String>((ref) => '');

// final searchedProvider = StateNotifierProvider<notifier, state>((ref) {

// });

class SearchedNotifier extends StateNotifier<List<MultiSearch>> {
  SearchedNotifier() : super([]);

  // Future<List<MultiSearch>> searchByQuery(String query) async{

  // }
}

typedef GetSearchCallback = Future<List<MultiSearch>> Function(String query);

class SearchNotifier extends StateNotifier<List<MultiSearch>> {
  GetSearchCallback getSearch;

  SearchNotifier({required this.getSearch}) : super([]);
}
*/

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
