class CrewPerson {
  final int id;
  final String name;
  final String originalName;
  final bool adult;
  final String? profilePath;
  final String department;
  final String job;
  final String creditId;
  final double popularity;
  final int gender;
  String? uniqueID;

  CrewPerson({
    required this.id,
    required this.name,
    required this.originalName,
    required this.adult,
    this.profilePath,
    required this.department,
    required this.job,
    required this.creditId,
    required this.popularity,
    required this.gender,
    this.uniqueID,
  });
}
