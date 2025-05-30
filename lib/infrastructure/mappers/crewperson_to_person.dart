import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/domain/entities/crew_person.dart' as domain;
import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';

extension CrewPersonToPerson on domain.CrewPerson {
  Person toPerson() {
    return Person(
      id: id,
      name: name,
      originalName: name,
      mediaType: MediaType.PERSON,
      adult: false,
      popularity: popularity,
      gender: gender,
      knownForDepartment: parseKnownForDepartment(department),
      profilePath: profilePath,
      uniqueID: uniqueID,
    );
  }
}