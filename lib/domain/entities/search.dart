import 'package:cinemania/domain/entities/known_for.dart';

class MultiSearch {
  final int id;
  final String? name;
  final String? originalName;
  final String mediaType;
  final bool adult;
  final double popularity;
  final int? gender;
  final String? knownForDepartment;
  final dynamic profilePath;
  final List<KnownFor>? knownFor;
  final String? backdropPath;
  final String? overview;
  final String? posterPath;
  final String? originalLanguage;
  final List<int>? genreIds;
  final DateTime? firstAirDate;
  final double? voteAverage;
  final int? voteCount;
  final List<String>? originCountry;
  final String? title;
  final String? originalTitle;
  final DateTime? releaseDate;
  final bool? video;

  MultiSearch({
    required this.id,
    this.name,
    this.originalName,
    required this.mediaType,
    required this.adult,
    required this.popularity,
    this.gender,
    this.knownForDepartment,
    this.profilePath,
    this.knownFor,
    this.backdropPath,
    this.overview,
    this.posterPath,
    this.originalLanguage,
    this.genreIds,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
    this.originCountry,
    this.title,
    this.originalTitle,
    this.releaseDate,
    this.video,
  });
}
