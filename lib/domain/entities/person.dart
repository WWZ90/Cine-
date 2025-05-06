import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';

class Person {
  final int id;
  String? uniqueID;
  final String name;
  final String originalName;
  final MediaType? mediaType;
  final bool adult;
  final double popularity;
  final int gender;
  final KnownForDepartment? knownForDepartment;
  final String? profilePath;

  Person({
    required this.id,
    required this.name,
    required this.originalName,
    required this.mediaType,
    required this.adult,
    required this.popularity,
    required this.gender,
    this.knownForDepartment,
    required this.profilePath,
  });
}
