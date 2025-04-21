import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/infrastructure/models/moviedb/tvshow_moviedb.dart';

class TvShowMapper {
  static TVShow tvShowToEntity(TVShowDB tvShow) => TVShow(
    adult: tvShow.adult,
    backdropPath:
        tvShow.backdropPath != ''
            ? 'https://image.tmdb.org/t/p/w500${tvShow.backdropPath}'
            : 'no-poster',
    genreIds: tvShow.genreIds,
    id: tvShow.id,
    originCountry: tvShow.originCountry,
    originalLanguage: tvShow.originalLanguage,
    originalName: tvShow.originalName,
    overview: tvShow.overview,
    popularity: tvShow.popularity,
    posterPath:
        tvShow.posterPath != ''
            ? 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}'
            : 'no-poster',
    firstAirDate: tvShow.firstAirDate,
    name: tvShow.name,
    voteAverage: tvShow.voteAverage,
    voteCount: tvShow.voteCount,
  );
}
