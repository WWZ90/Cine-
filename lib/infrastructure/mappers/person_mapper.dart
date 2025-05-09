import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';

class PersonMapper {
  static Person personToEntity(PersonMoviedb person) => Person(
    id: person.id,
    name: person.name,
    originalName: person.originalName,
    mediaType: person.mediaType ?? MediaType.PERSON,
    adult: person.adult,
    popularity: person.popularity,
    gender: person.gender,
    knownForDepartment: person.knownForDepartment ?? KnownForDepartment.ACTING,
    profilePath:
        person.profilePath != ''
            ? 'https://image.tmdb.org/t/p/w500${person.profilePath}'
            : 'no-poster',
  );
}
