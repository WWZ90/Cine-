import 'package:cinemania/domain/entities/cast_person.dart';
import 'package:cinemania/infrastructure/models/moviedb/credits_response.dart';

class CastMapper {
  static CastPerson castToEntity(Cast cast) => CastPerson(
    id: cast.id,
    name: cast.name,
    character: cast.character,
    profilePath:
        cast.profilePath != ''
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'no-avatar',
  );
}
