import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/movies/movies_repository_provider.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fecthMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
      return MoviesNotifier(fetchMoreMovies: fecthMoreMovies);
    });

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fecthMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
      return MoviesNotifier(fetchMoreMovies: fecthMoreMovies);
    });

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fecthMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
      return MoviesNotifier(fetchMoreMovies: fecthMoreMovies);
    });

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
      final fecthMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
      return MoviesNotifier(fetchMoreMovies: fecthMoreMovies);
    });

final similarMoviesProvider = StateNotifierProvider.family<
  MoviesNotifier,
  List<Movie>,
  String
>((ref, movieId) {
  // Creamos un closure que solo expone {int page} y ya llama al repositorio con movieId
  fetchMoreMovies({int page = 1}) =>
      ref.read(movieRepositoryProvider).getSimilar(movieId, page: page);

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final moviesByGenreProvider = StateNotifierProvider.family<
  MoviesNotifier,
  List<Movie>,
  String
>((ref, genreId) {
  // Creamos un closure que solo expone {int page} y ya llama al repositorio con movieId
  fetchMoreMovies({int page = 1}) =>
      ref.read(movieRepositoryProvider).getMoviesByGenreId(genreId, page: page);

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;

  MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    print('loading new movies');

    final List<Movie> movies = await fetchMoreMovies(page: currentPage);

    state = [...state, ...movies];
    await Future.delayed(Duration(milliseconds: 400));
    isLoading = false;
  }
}
