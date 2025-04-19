import 'package:cinemania/domain/entities/genre.dart';
import 'package:cinemania/presentation/providers/genres/genres_movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final genresMovieProvider =
    StateNotifierProvider<GenresMoviesNotifier, List<Genre>>((
      ref,
    ) {
      final genresMoviesRepository = ref.watch(genresMoviesRepositoryProvider);
      return GenresMoviesNotifier(getGenres: genresMoviesRepository.getGenresMovie);
    });


typedef GetGenresMovieCallback = Future<List<Genre>> Function();

class GenresMoviesNotifier
    extends StateNotifier<List<Genre>> {
  
  final GetGenresMovieCallback getGenres;
  GenresMoviesNotifier({required this.getGenres}) : super([]);

  Future<void> loadGenres() async {
    final List<Genre> genres = await getGenres();
    state = [...state, ...genres];
  }
}
