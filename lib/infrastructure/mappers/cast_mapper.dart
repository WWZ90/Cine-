import 'package:cinemania/domain/entities/cast_person.dart';
import 'package:cinemania/infrastructure/models/moviedb/credits_response.dart';

class CastMapper {
  static CastPerson castToEntity(Cast cast) => CastPerson(
    adult: cast.adult,
    gender: cast.gender,
    id: cast.id,
    knownForDepartment: cast.knownForDepartment,
    name: cast.name,
    originalName: cast.originalName,
    popularity: cast.popularity,
    profilePath: cast.profilePath != ''
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'no-avatar',
    character: cast.character!,
    order: cast.order!,
  );
}