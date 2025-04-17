import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/presentation/providers/movies/movies_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieDetailProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
      final movieRepository = ref.watch(movieRepositoryProvider);
      return MovieMapNotifier(
        getMovie:
            (id, {cancelToken}) =>
                movieRepository.getMovieById(id, cancelToken: cancelToken),
      );
    });

typedef GetMovieCallback =
    Future<Movie> Function(String movieId, {CancelToken? cancelToken});

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  CancelToken? _cancelToken;
  final GetMovieCallback getMovie;
  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;

    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    final movie = await getMovie(movieId, cancelToken: _cancelToken!);

    state = {...state, movieId: movie};
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }
}
