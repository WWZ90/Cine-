class Movie {
  final int id;
  String? uniqueID;
  final String title;
  final String originalTitle;
  final bool adult;
  final String posterPath;
  final String backdropPath;
  final List<int> genreIds;
  final String originalLanguage;
  final String overview;
  final double popularity;
  final DateTime releaseDate;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.adult,
    required this.posterPath,
    required this.backdropPath,
    required this.genreIds,
    required this.originalLanguage,
    required this.overview,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });
}
