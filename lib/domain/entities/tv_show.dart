import 'package:isar/isar.dart';

part 'tv_show.g.dart';

@collection
class TVShow {
  Id? isarTVShowId;

  final int id;
  String? uniqueID;
  final String title;
  final String originalTitle;
  final bool adult;
  final String posterPath;
  final String backdropPath;
  final List<int> genreIds;
  final List<String> originCountry;
  final String originalLanguage;
  final String overview;
  final double popularity;
  final DateTime? firstAirDate;
  final double voteAverage;
  final int voteCount;

  TVShow({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.originCountry,
    required this.originalLanguage,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
  });
}
