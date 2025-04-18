import 'package:cinemania/domain/entities/movie_detail.dart';
import 'package:cinemania/infrastructure/models/moviedb/movie_details.dart';

class MovieDetailMapper {
  static MovieDetail movieDetailsToEntity(
    MovieDetailsResponse movie,
  ) => MovieDetail(
    backdropPath:
        movie.backdropPath != ''
            ? 'https://image.tmdb.org/t/p/w500${movie.backdropPath}'
            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoWcWg0E8pSjBNi0TtiZsqu8uD2PAr_K11DA&s',

    id: movie.id,

    overview: movie.overview,

    posterPath:
        movie.posterPath != ''
            ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoWcWg0E8pSjBNi0TtiZsqu8uD2PAr_K11DA&s',
    releaseDate: movie.releaseDate,
    title: movie.title,
    voteAverage: movie.voteAverage.toDouble(),
    voteCount: movie.voteCount,
    runtime: movie.runtime,
    budget: movie.budget,
    revenue: movie.revenue,
    status: movie.status,
    tagline: movie.tagline,
    homepage: movie.homepage,
    genres: movie.genres,
  );
}
