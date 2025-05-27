import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/movies/movies_repository_provider.dart';

typedef MovieCallback = Future<List<Movie>> Function({int page});

// Estado que contiene la lista de películas + si está cargando
class MoviesState {
  final List<Movie> movies;
  final bool isLoading;

  MoviesState({required this.movies, required this.isLoading});

  MoviesState copyWith({List<Movie>? movies, bool? isLoading}) {
    return MoviesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Notifier que maneja el estado con paginación y carga
class MoviesNotifier extends StateNotifier<MoviesState> {
  int currentPage = 0;
  final MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies})
    : super(MoviesState(movies: [], isLoading: false));

  Future<void> loadNextPage() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    currentPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = MoviesState(movies: [...state.movies, ...movies], isLoading: false);
  }

  Future<void> reset() async {
    currentPage = 0;
    state = MoviesState(movies: [], isLoading: false);
    await loadNextPage();
  }
}

class MoviesByPersonState {
  final List<Movie> allMovies;
  final List<Movie> visibleMovies;
  final bool isLoading;
  final bool hasReachedEnd;

  MoviesByPersonState({
    required this.allMovies,
    required this.visibleMovies,
    required this.isLoading,
    required this.hasReachedEnd,
  });

  factory MoviesByPersonState.initial() => MoviesByPersonState(
    allMovies: [],
    visibleMovies: [],
    isLoading: true,
    hasReachedEnd: false,
  );

  MoviesByPersonState copyWith({
    List<Movie>? allMovies,
    List<Movie>? visibleMovies,
    bool? isLoading,
    bool? hasReachedEnd,
  }) {
    return MoviesByPersonState(
      allMovies: allMovies ?? this.allMovies,
      visibleMovies: visibleMovies ?? this.visibleMovies,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class MoviesByPersonNotifier extends StateNotifier<MoviesByPersonState> {
  final dynamic repository;
  final String personId;
  static const int localPageSize = 10;

  MoviesByPersonNotifier({required this.repository, required this.personId})
    : super(MoviesByPersonState.initial()) {
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final all = await repository.getMoviesByPersonId(personId);
    final initial = all.take(localPageSize).toList();
    state = state.copyWith(
      allMovies: all,
      visibleMovies: initial,
      isLoading: false,
      hasReachedEnd: initial.length >= all.length,
    );
  }

  void loadMoreLocally() {
    if (state.isLoading || state.hasReachedEnd) return;

    final current = state.visibleMovies.length;
    final more = state.allMovies.skip(current).take(localPageSize).toList();
    final updated = [...state.visibleMovies, ...more];

    state = state.copyWith(
      visibleMovies: updated,
      hasReachedEnd: updated.length >= state.allMovies.length,
    );
  }
}

final moviesByPersonProvider = StateNotifierProvider.family<
  MoviesByPersonNotifier,
  MoviesByPersonState,
  String
>((ref, personId) {
  final repo = ref.watch(movieRepositoryProvider);
  return MoviesByPersonNotifier(repository: repo, personId: personId);
});

// Providers por categoría

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, MoviesState>((ref) {
      final fecthMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
      return MoviesNotifier(fetchMoreMovies: fecthMoreMovies);
    });

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, MoviesState>((ref) {
      final fecthMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
      return MoviesNotifier(fetchMoreMovies: fecthMoreMovies);
    });

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, MoviesState>((ref) {
      final fecthMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
      return MoviesNotifier(fetchMoreMovies: fecthMoreMovies);
    });

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, MoviesState>((ref) {
      final fecthMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
      return MoviesNotifier(fetchMoreMovies: fecthMoreMovies);
    });

// Providers familiares

final similarMoviesProvider =
    StateNotifierProvider.family<MoviesNotifier, MoviesState, String>((
      ref,
      movieId,
    ) {
      fetchMoreMovies({int page = 1}) =>
          ref.read(movieRepositoryProvider).getSimilar(movieId, page: page);

      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
    });

final moviesByGenreProvider = StateNotifierProvider.family<
  MoviesNotifier,
  MoviesState,
  String
>((ref, genreId) {
  fetchMoreMovies({int page = 1}) =>
      ref.read(movieRepositoryProvider).getMoviesByGenreId(genreId, page: page);

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final movieProvider =
    FutureProvider.family<Movie?, ({int movieId})>((
      ref,
      params,
    ) async {
      final datasource = ref.watch(movieRepositoryProvider);
      return await datasource.getMovieById(params.movieId.toString());
    });
