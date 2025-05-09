class PersonDetailsResponse {
  final bool adult;
  final List<String> alsoKnownAs;
  final String? biography;
  final DateTime? birthday;
  final dynamic deathday;
  final int gender;
  final int id;
  final String? imdbId;
  final String? knownForDepartment;
  final String name;
  final String? placeOfBirth;
  final double popularity;
  final String? profilePath;

  PersonDetailsResponse({
    required this.adult,
    required this.alsoKnownAs,
    this.biography,
    this.birthday,
    this.deathday,
    required this.gender,
    required this.id,
    this.imdbId,
    this.knownForDepartment,
    required this.name,
    this.placeOfBirth,
    required this.popularity,
    this.profilePath,
  });

  factory PersonDetailsResponse.fromJson(Map<String, dynamic> json) =>
      PersonDetailsResponse(
        adult: json["adult"] ?? false,
        alsoKnownAs:
            json["also_known_as"] != null
                ? List<String>.from(json["also_known_as"].map((x) => x))
                : [],
        biography: json["biography"],
        birthday:
            json["birthday"] != null
                ? DateTime.tryParse(json["birthday"])
                : null,
        deathday: json["deathday"],
        gender: json["gender"] ?? 0,
        id: json["id"],
        imdbId: json["imdb_id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"],
        popularity: (json["popularity"] ?? 0).toDouble(),
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "also_known_as": List<dynamic>.from(alsoKnownAs.map((x) => x)),
    "biography": biography,
    "birthday":
        birthday != null
            ? "${birthday!.year.toString().padLeft(4, '0')}-${birthday!.month.toString().padLeft(2, '0')}-${birthday!.day.toString().padLeft(2, '0')}"
            : null,
    "deathday": deathday,
    "gender": gender,
    "id": id,
    "imdb_id": imdbId,
    "known_for_department": knownForDepartment,
    "name": name,
    "place_of_birth": placeOfBirth,
    "popularity": popularity,
    "profile_path": profilePath,
  };
}
