import 'package:isar/isar.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';

part 'person.g.dart';

@collection
class Person {
  Id? isarPersonId;

  final int id;
  String? uniqueID;
  final String name;
  final String originalName;
  @enumerated
  final MediaType mediaType;
  final bool adult;
  final double popularity;
  final int gender;
  @enumerated
  final KnownForDepartment knownForDepartment;
  final String? profilePath;

  Person({
    required this.id,
    required this.name,
    required this.originalName,
    required this.mediaType,
    required this.adult,
    required this.popularity,
    required this.gender,
    required this.knownForDepartment,
    required this.profilePath,
    this.uniqueID,
  });
}
