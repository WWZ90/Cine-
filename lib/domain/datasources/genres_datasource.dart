import 'package:cinemania/domain/entities/genre.dart';

abstract class GenresDatasource {
  Future<List<Genre>> getGenresMovie();
  Future<List<Genre>> getGenresTVShow();
}
