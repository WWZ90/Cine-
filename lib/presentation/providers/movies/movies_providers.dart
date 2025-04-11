import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
