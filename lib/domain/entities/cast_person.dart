class CastPerson {
  final int id;
  final String name;
  final String profilePath;
  final String? character;

  CastPerson({
    required this.id,
    required this.name,
    required this.profilePath,
    this.character,
  });
}
