import 'package:cinemania/domain/entities/tv_show_details.dart';
import 'package:cinemania/infrastructure/models/moviedb/tvshow_details.dart';

class TvShowDetailMapper {
  static TvShowDetails tvShowDetailsToEntity(
    TvShowDetailsResponse tvShowDetails,
  ) => TvShowDetails(
    adult: tvShowDetails.adult,
    backdropPath: tvShowDetails.backdropPath != '' ? 'https://image.tmdb.org/t/p/w500${tvShowDetails.backdropPath}' : 'no-poster',
    createdBy: tvShowDetails.createdBy,
    episodeRunTime: tvShowDetails.episodeRunTime,
    firstAirDate: tvShowDetails.firstAirDate,
    genres: tvShowDetails.genres,
    homepage: tvShowDetails.homepage,
    id: tvShowDetails.id,
    inProduction: tvShowDetails.inProduction,
    languages: tvShowDetails.languages,
    lastAirDate: tvShowDetails.lastAirDate,
    lastEpisodeToAir: tvShowDetails.lastEpisodeToAir,
    name: tvShowDetails.name,
    nextEpisodeToAir: tvShowDetails.nextEpisodeToAir,
    networks: tvShowDetails.networks,
    numberOfEpisodes: tvShowDetails.numberOfEpisodes,
    numberOfSeasons: tvShowDetails.numberOfSeasons,
    originCountry: tvShowDetails.originCountry,
    originalLanguage: tvShowDetails.originalLanguage,
    originalName: tvShowDetails.originalName,
    overview: tvShowDetails.overview,
    popularity: tvShowDetails.popularity,
    posterPath: tvShowDetails.posterPath != '' ? 'https://image.tmdb.org/t/p/w500${tvShowDetails.posterPath}' : 'no-poster',
    productionCompanies: tvShowDetails.productionCompanies,
    productionCountries: tvShowDetails.productionCountries,
    seasons: tvShowDetails.seasons,
    spokenLanguages: tvShowDetails.spokenLanguages,
    status: tvShowDetails.status,
    tagline: tvShowDetails.tagline,
    type: tvShowDetails.type,
    voteAverage: tvShowDetails.voteAverage,
    voteCount: tvShowDetails.voteCount,
  );
}
