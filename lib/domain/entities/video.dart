class Video {
  final Iso6391 iso6391;
  final Iso31661 iso31661;
  final String name;
  final String key;
  final Site site;
  final int size;
  final Type type;
  final bool official;
  final DateTime publishedAt;
  final String id;

  Video({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });
}


enum Iso31661 {
    US
}

final iso31661Values = EnumValues({
    "US": Iso31661.US
});

enum Iso6391 {
    EN
}

final iso6391Values = EnumValues({
    "en": Iso6391.EN
});

enum Site {
    YOU_TUBE
}

final siteValues = EnumValues({
    "YouTube": Site.YOU_TUBE
});

enum Type {
    BEHIND_THE_SCENES,
    CLIP,
    FEATURETTE,
    TEASER,
    TRAILER
}

final typeValues = EnumValues({
    "Behind the Scenes": Type.BEHIND_THE_SCENES,
    "Clip": Type.CLIP,
    "Featurette": Type.FEATURETTE,
    "Teaser": Type.TEASER,
    "Trailer": Type.TRAILER
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}