import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/domain/entities/cast_person.dart' as domain;
import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';

extension CastPersonToPerson on domain.CastPerson {
  Person toPerson() {
    return Person(
      id: id,
      name: name,
      originalName: name,
      mediaType: MediaType.PERSON,
      adult: false,
      popularity: popularity,
      gender: gender,
      knownForDepartment: KnownForDepartment.ACTING,
      profilePath: profilePath,
    );
  }
}