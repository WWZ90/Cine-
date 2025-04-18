import 'package:cinemania/infrastructure/models/moviedb/movie_details.dart';

class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final int runtime;
  final DateTime releaseDate;
  final int budget;
  final int revenue;
  final String status;
  final String tagline;
  final String homepage;
  final List<Genre> genres;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.runtime,
    required this.releaseDate,
    required this.budget,
    required this.revenue,
    required this.status,
    required this.tagline,
    required this.homepage,
    required this.genres,
  });
}
