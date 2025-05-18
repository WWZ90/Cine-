import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';

typedef TvShowCallBack = Future<List<TVShow>> Function({int page});

// Estado compuesto: lista + estado de carga
class TVShowState {
  final List<TVShow> shows;
  final bool isLoading;

  TVShowState({required this.shows, required this.isLoading});

  TVShowState copyWith({List<TVShow>? shows, bool? isLoading}) {
    return TVShowState(
      shows: shows ?? this.shows,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Notifier que maneja estado y paginación
class TvShowNotifier extends StateNotifier<TVShowState> {
  int currentPage = 0;
  final TvShowCallBack fetchMoreTVShows;

  TvShowNotifier({required this.fetchMoreTVShows})
    : super(TVShowState(shows: [], isLoading: false));

  Future<void> loadNextPage() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    currentPage++;

    final List<TVShow> tvShows = await fetchMoreTVShows(page: currentPage);
    state = TVShowState(shows: [...state.shows, ...tvShows], isLoading: false);
  }

  Future<void> reset() async {
    currentPage = 0;
    state = TVShowState(shows: [], isLoading: false);
    await loadNextPage();
  }
}

class TVShowsByPersonState {
  final List<TVShow> allShows;
  final List<TVShow> visibleShows;
  final bool isLoading;
  final bool hasReachedEnd;

  TVShowsByPersonState({
    required this.allShows,
    required this.visibleShows,
    required this.isLoading,
    required this.hasReachedEnd,
  });

  factory TVShowsByPersonState.initial() => TVShowsByPersonState(
    allShows: [],
    visibleShows: [],
    isLoading: true,
    hasReachedEnd: false,
  );

  TVShowsByPersonState copyWith({
    List<TVShow>? allShows,
    List<TVShow>? visibleShows,
    bool? isLoading,
    bool? hasReachedEnd,
  }) {
    return TVShowsByPersonState(
      allShows: allShows ?? this.allShows,
      visibleShows: visibleShows ?? this.visibleShows,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class TVShowsByPersonNotifier extends StateNotifier<TVShowsByPersonState> {
  final dynamic repository;
  final String personId;
  static const int localPageSize = 10;

  TVShowsByPersonNotifier({required this.repository, required this.personId})
    : super(TVShowsByPersonState.initial()) {
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final all = await repository.getTVShowByPersonId(personId);
    final initial = all.take(localPageSize).toList();
    state = state.copyWith(
      allShows: all,
      visibleShows: initial,
      isLoading: false,
      hasReachedEnd: initial.length >= all.length,
    );
  }

  void loadMoreLocally() {
    if (state.isLoading || state.hasReachedEnd) return;

    final current = state.visibleShows.length;
    final more = state.allShows.skip(current).take(localPageSize).toList();
    final updated = [...state.visibleShows, ...more];

    state = state.copyWith(
      visibleShows: updated,
      hasReachedEnd: updated.length >= state.allShows.length,
    );
  }
}

// Providers

final tvShowsByPersonProvider = StateNotifierProvider.family<
  TVShowsByPersonNotifier,
  TVShowsByPersonState,
  String
>((ref, personId) {
  final repo = ref.watch(tvShowRepositoryProvider);
  return TVShowsByPersonNotifier(repository: repo, personId: personId);
});

final airingTodayTVShowsProvider =
    StateNotifierProvider<TvShowNotifier, TVShowState>((ref) {
      final fetchMore = ref.watch(tvShowRepositoryProvider).getAiringToday;
      return TvShowNotifier(fetchMoreTVShows: fetchMore);
    });

final onTheAirTVShowsProvider =
    StateNotifierProvider<TvShowNotifier, TVShowState>((ref) {
      final fetchMore = ref.watch(tvShowRepositoryProvider).getOnTheAir;
      return TvShowNotifier(fetchMoreTVShows: fetchMore);
    });

final popularTVShowsProvider =
    StateNotifierProvider<TvShowNotifier, TVShowState>((ref) {
      final fetchMore = ref.watch(tvShowRepositoryProvider).getPopular;
      return TvShowNotifier(fetchMoreTVShows: fetchMore);
    });

final topRatedTVShowsProvider =
    StateNotifierProvider<TvShowNotifier, TVShowState>((ref) {
      final fetchMore = ref.watch(tvShowRepositoryProvider).getTopRated;
      return TvShowNotifier(fetchMoreTVShows: fetchMore);
    });

// Providers familiares

final similarTVShowsProvider =
    StateNotifierProvider.family<TvShowNotifier, TVShowState, String>((
      ref,
      id,
    ) {
      fetchMoreTVShows({int page = 1}) =>
          ref.read(tvShowRepositoryProvider).getSimilar(id, page: page);

      return TvShowNotifier(fetchMoreTVShows: fetchMoreTVShows);
    });

final tvShowsByGenreProvider =
    StateNotifierProvider.family<TvShowNotifier, TVShowState, String>((
      ref,
      genreId,
    ) {
      fetchMoreTVShows({int page = 1}) => ref
          .read(tvShowRepositoryProvider)
          .getTVShowByGenreId(genreId, page: page);

      return TvShowNotifier(fetchMoreTVShows: fetchMoreTVShows);
    });

// final tvShowsByPersonProvider =
//     StateNotifierProvider.family<TvShowNotifier, TVShowState, String>((
//       ref,
//       personId,
//     ) {
//       fetchMoreTVShows({int page = 1}) =>
//           ref.read(tvShowRepositoryProvider).getTVShowByPersonId(personId);

//       return TvShowNotifier(fetchMoreTVShows: fetchMoreTVShows);
//     });
