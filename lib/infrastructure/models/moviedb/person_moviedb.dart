class PersonMoviedb {
  final int id;
  final String name;
  final String originalName;
  final MediaType? mediaType;
  final bool adult;
  final double popularity;
  final int gender;
  final KnownForDepartment? knownForDepartment;
  final String? profilePath;

  PersonMoviedb({
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

  factory PersonMoviedb.fromJson(Map<String, dynamic> json) => PersonMoviedb(
    id: json["id"],
    name: json["name"],
    originalName: json["original_name"],
    mediaType:
        json["media_type"] != null
            ? mediaTypeValues.map[json["media_type"]]!
            : null,
    adult: json["adult"],
    popularity: json["popularity"]?.toDouble(),
    gender: json["gender"],
    knownForDepartment:
        json["known_for_department"] != null
            ? knownForDepartmentValues.map[json["known_for_department"]]!
            : null,
    profilePath: json["profile_path"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "original_name": originalName,
    "media_type": mediaTypeValues.reverse[mediaType],
    "adult": adult,
    "popularity": popularity,
    "gender": gender,
    "known_for_department":
        knownForDepartmentValues.reverse[knownForDepartment],
    "profile_path": profilePath,
  };
}

enum KnownForDepartment {
  ACTING,
  DIRECTING,
  SOUND,
  WRITING,
  PRODUCTION,
  CREW,
  ART,
  EDITING,
  CAMERA,
  COSTUME_MAKEUP,
  VISUAL_EFFECTS,
  LIGHTING,
  UNKNOWN,
}

final knownForDepartmentValues = EnumValues({
  "Acting": KnownForDepartment.ACTING,
  "Directing": KnownForDepartment.DIRECTING,
  "Sound": KnownForDepartment.SOUND,
  "Writing": KnownForDepartment.WRITING,
  "Production": KnownForDepartment.PRODUCTION,
  "Crew": KnownForDepartment.CREW,
  "Art": KnownForDepartment.ART,
  "Editing": KnownForDepartment.EDITING,
  "Costume & Make-Up": KnownForDepartment.COSTUME_MAKEUP,
  "Visual effects": KnownForDepartment.VISUAL_EFFECTS,
  "Lighting": KnownForDepartment.LIGHTING,
  "Unknown": KnownForDepartment.UNKNOWN,

});

KnownForDepartment parseKnownForDepartment(String? value) {
  switch (value?.toLowerCase()) {
    case 'acting':
      return KnownForDepartment.ACTING;
    case 'directing':
      return KnownForDepartment.DIRECTING;
    case 'writing':
      return KnownForDepartment.WRITING;
    case 'sound':
      return KnownForDepartment.SOUND;
    case 'production':
      return KnownForDepartment.PRODUCTION;
    case 'art':
      return KnownForDepartment.ART;
    case 'editing':
      return KnownForDepartment.EDITING;
    case 'camera':
      return KnownForDepartment.CAMERA;
    case 'costume & make-up':
      return KnownForDepartment.COSTUME_MAKEUP;
    case 'visual effects':
      return KnownForDepartment.VISUAL_EFFECTS;
    case 'lighting':
      return KnownForDepartment.LIGHTING;
    case 'crew':
      return KnownForDepartment.CREW;
    default:
      return KnownForDepartment.UNKNOWN;
  }
}

enum MediaType { PERSON }

final mediaTypeValues = EnumValues({"person": MediaType.PERSON});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
