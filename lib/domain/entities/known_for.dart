class KnownFor {
  final String? backdropPath;
  final int id;
  final String title;
  final String name;
  final String originalTitle;
  final String originalName;
  final String overview;
  final String? posterPath;
  final String mediaType;
  final bool adult;
  final String originalLanguage;
  final List<int> genreIds;
  final double popularity;
  final String releaseDate;
  final String firstAirDate;
  final bool video;
  final double voteAverage;
  final int voteCount;

  KnownFor({
    required this.backdropPath,
    required this.id,
    required this.title,
    required this.name,
    required this.originalTitle,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.adult,
    required this.originalLanguage,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.firstAirDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory KnownFor.fromJson(Map<String, dynamic> json) => KnownFor(
    backdropPath: json["backdrop_path"],
    id: json["id"],
    title: json["title"] ?? '',
    name: json["name"] ?? '',
    originalTitle: json["original_title"] ?? '',
    originalName: json["original_name"] ?? '',
    overview: json["overview"],
    posterPath: json["poster_path"],
    mediaType: json["media_type"],
    adult: json["adult"],
    originalLanguage: json["original_language"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    popularity: json["popularity"]?.toDouble(),
    releaseDate: json["release_date"] ?? '',
    firstAirDate: json["first_air_date"] ?? '',
    video: json["video"] ?? false,
    voteAverage: json["vote_average"],
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "backdrop_path": backdropPath,
    "id": id,
    "title": title,
    "original_title": originalTitle,
    "overview": overview,
    "poster_path": posterPath,
    "media_type": mediaType,
    "adult": adult,
    "original_language": originalLanguage,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "popularity": popularity,
    "release_date": releaseDate,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}
