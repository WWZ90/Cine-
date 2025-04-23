import 'package:cinemania/domain/entities/genre.dart';

abstract class GenresRepository {
  Future<List<Genre>> getGenresMovie();
    Future<List<Genre>> getGenresTVShow();
}
