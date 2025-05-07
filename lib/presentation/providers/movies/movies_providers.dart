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
    : super(MoviesState(movies: [], isLoading: false)) {
    loadNextPage(); // carga inicial
  }

  Future<void> loadNextPage() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    currentPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = MoviesState(movies: [...state.movies, ...movies], isLoading: false);
  }
}

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

final moviesByPersonProvider =
    StateNotifierProvider.family<MoviesNotifier, MoviesState, String>((
      ref,
      personId,
    ) {
      fetchMoreMovies({int page = 1}) =>
          ref.read(movieRepositoryProvider).getMoviesByPersonId(personId);

      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
    });
