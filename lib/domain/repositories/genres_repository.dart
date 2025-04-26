import 'package:cinemania/domain/entities/entities.dart';

abstract class GenresRepository {
  Future<List<Genre>> getGenresMovie();
    Future<List<Genre>> getGenresTVShow();
}
