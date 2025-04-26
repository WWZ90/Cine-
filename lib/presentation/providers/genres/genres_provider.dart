import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/genres/genres_repository_provider.dart';
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

final genresTVShowProvider =
    StateNotifierProvider<GenresTVShowNotifier, List<Genre>>((
      ref,
    ) {
      final genresTVShowRepository = ref.watch(genresTVShowRepositoryProvider);
      return GenresTVShowNotifier(getGenres: genresTVShowRepository.getGenresTVShow);
    });


typedef GetGenresTVShowCallback = Future<List<Genre>> Function();

class GenresTVShowNotifier
    extends StateNotifier<List<Genre>> {
  
  final GetGenresTVShowCallback getGenres;
  GenresTVShowNotifier({required this.getGenres}) : super([]);

  Future<void> loadGenres() async {
    final List<Genre> genres = await getGenres();
    state = [...state, ...genres];
  }
}
