import 'package:cinemania/domain/entities/genre.dart';
import 'package:cinemania/infrastructure/models/moviedb/genres_response.dart';

class GenreMapper {
  static Genre genreToEntity(GenreMovieDb genre, {required String locale}) {
    String name = genre.name;

    if (locale == 'es') {
      final corrections = {
        'Action & Adventure': 'Acción y Aventura',
        'Sci-Fi & Fantasy': 'Ciencia ficción y fantasía',
        'Kids': 'Infantil',
        'War & Politics': 'Guerra y Política',
        'Soap': 'Telenovela',
        'Reality': 'Reality Show',
        'Western': 'Oeste',
        'News': 'Noticias',
      };

      name = corrections[name] ?? name;
    }

    return Genre(id: genre.id, name: name);
  }
}
