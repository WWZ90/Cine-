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
    : super(TVShowState(shows: [], isLoading: false)) {
    loadNextPage(); // carga inicial
  }

  Future<void> loadNextPage() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    currentPage++;

    final List<TVShow> tvShows = await fetchMoreTVShows(page: currentPage);
    state = TVShowState(shows: [...state.shows, ...tvShows], isLoading: false);
  }
}

// Providers

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

final tvShowsByPersonProvider =
    StateNotifierProvider.family<TvShowNotifier, TVShowState, String>((
      ref,
      personId,
    ) {
      fetchMoreTVShows({int page = 1}) =>
          ref.read(tvShowRepositoryProvider).getTVShowByPersonId(personId);

      return TvShowNotifier(fetchMoreTVShows: fetchMoreTVShows);
    });
