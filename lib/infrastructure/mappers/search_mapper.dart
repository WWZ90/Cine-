import 'package:cinemania/domain/entities/search.dart';
import 'package:cinemania/infrastructure/models/moviedb/searchs_response.dart';

class SearchMapper {
  static MultiSearch searchToEntity(SearchDB search) => MultiSearch(
    id: search.id,
    mediaType: search.mediaType,
    adult: search.adult,
    popularity: search.popularity,
    backdropPath: search.backdropPath != null
            ? 'https://image.tmdb.org/t/p/w500${search.backdropPath}'
            : 'no-poster',
    firstAirDate: search.firstAirDate,
    gender: search.gender,
    genreIds: search.genreIds,
    knownFor: search.knownFor,
    knownForDepartment: search.knownForDepartment,
    name: search.name,
    originCountry: search.originCountry,
    originalLanguage: search.originalLanguage,
    originalName: search.originalName,
    originalTitle: search.originalTitle,
    overview: search.overview,
    posterPath: search.posterPath != null
            ? 'https://image.tmdb.org/t/p/w500${search.posterPath}'
            : 'no-poster',
    profilePath:
        search.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500${search.profilePath}'
            : 'no-avatar',
    releaseDate: search.releaseDate,
    title: search.title,
    video: search.video,
    voteAverage: search.voteAverage,
    voteCount: search.voteCount,
  );
}
