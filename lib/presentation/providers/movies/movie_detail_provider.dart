import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/movies/movies_repository_provider.dart';

final movieDetailProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, MovieDetail>>((ref) {
      final movieRepository = ref.watch(movieRepositoryProvider);
      return MovieMapNotifier(
        getMovie:
            (id, {cancelToken}) =>
                movieRepository.getMovieById(id, cancelToken: cancelToken),
      );
    });

typedef GetMovieCallback =
    Future<MovieDetail> Function(String movieId, {CancelToken? cancelToken});

class MovieMapNotifier extends StateNotifier<Map<String, MovieDetail>> {
  CancelToken? _cancelToken;
  final GetMovieCallback getMovie;
  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    try {
      if (state[movieId] != null) return;

      _cancelToken?.cancel();
      _cancelToken = CancelToken();

      final movie = await getMovie(movieId, cancelToken: _cancelToken!);

      state = {...state, movieId: movie};
    } catch (e) {
      throw Exception('Movie with id $movieId not found');
    }
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }
}
