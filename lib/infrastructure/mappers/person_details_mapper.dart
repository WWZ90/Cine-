import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_details_response.dart';

class PersonDetailsMapper {
  static PersonDetails personDetailsToEntity(PersonDetailsResponse person) =>
      PersonDetails(
        adult: person.adult,
        alsoKnownAs: person.alsoKnownAs,
        biography: person.biography ?? '',
        birthday: person.birthday,
        deathday: person.deathday,
        gender: person.gender,
        id: person.id,
        imdbId: person.imdbId ?? '',
        knownForDepartment: person.knownForDepartment ?? '',
        name: person.name,
        placeOfBirth: person.placeOfBirth ?? '',
        popularity: person.popularity,
        profilePath:
            (person.profilePath != null && person.profilePath!.isNotEmpty)
                ? 'https://image.tmdb.org/t/p/w500${person.profilePath}'
                : 'no-poster',
      );
}
