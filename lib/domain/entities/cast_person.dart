class CastPerson {
  final bool adult;
  final int gender;
  final int id;
  String? uniqueID;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String profilePath;
  final String character;
  final int order;

  CastPerson({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.character,
    required this.order,
    this.uniqueID,
  });
}
