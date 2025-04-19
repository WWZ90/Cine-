import 'package:cinemania/domain/entities/genre.dart';
import 'package:cinemania/infrastructure/models/moviedb/genres_response.dart';

class GenreMapper {
  static Genre genreToEntity(GenreMovieDb genre) =>
      Genre(id: genre.id, name: genre.name);
}
