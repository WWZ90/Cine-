import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onTheAirTVShowsProvider =
    StateNotifierProvider<TvShowNotifier, List<TVShow>>((ref) {
      final fetchMore = ref.watch(tvShowRepositoryProvider).getOnTheAir;
      return TvShowNotifier(fetchMoreTVShows: fetchMore);
    });

final popularTVShowsProvider =
    StateNotifierProvider<TvShowNotifier, List<TVShow>>((ref) {
      final fetchMore = ref.watch(tvShowRepositoryProvider).getPopular;
      return TvShowNotifier(fetchMoreTVShows: fetchMore);
    });

final topRatedTVShowsProvider =
    StateNotifierProvider<TvShowNotifier, List<TVShow>>((ref) {
      final fetchMore = ref.watch(tvShowRepositoryProvider).getTopRated;
      return TvShowNotifier(fetchMoreTVShows: fetchMore);
    });

typedef TvShowCallBack = Future<List<TVShow>> Function({int page});

class TvShowNotifier extends StateNotifier<List<TVShow>> {
  int currentPage = 0;
  bool isLoading = false;

  TvShowCallBack fetchMoreTVShows;

  TvShowNotifier({required this.fetchMoreTVShows}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    print('Loading new tv shows');

    final List<TVShow> tvShows = await fetchMoreTVShows(page: currentPage);

    state = [...state, ...tvShows];
    await Future.delayed(Duration(milliseconds: 400));
    isLoading = false;
  }
}
