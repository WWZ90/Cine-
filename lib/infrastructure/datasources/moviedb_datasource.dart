import 'package:dio/dio.dart';
import 'package:cinemania/config/global_app_state.dart';
import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/domain/entities/movie_detail.dart';
import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/domain/datasources/movies_datasource.dart';
import 'package:cinemania/infrastructure/models/moviedb/movie_moviedb.dart';
import 'package:cinemania/infrastructure/mappers/movie_detail_mapper.dart';
import 'package:cinemania/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemania/infrastructure/mappers/video_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemania/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemania/infrastructure/models/video/video_response.dart';

const Map<String, List<String>> crewRoleCategories = {
  'Director': ['Director', 'Co-Director'],
  'Producer': ['Producer', 'Executive Producer'],
  'Writer': ['Writer', 'Screenplay', 'Author', 'Story'],
  'Sound': ['Sound', 'Original Music Composer', 'Music'],
  'Other Crew Work': [],
};

class CrewMemberMovie extends MovieMovieDB {
  final String department;
  final String job;

  CrewMemberMovie({
    // Parámetros para MovieMovieDB (la superclase) usando super parámetros
    required super.adult,
    required super.backdropPath,
    required super.genreIds,
    required super.id,
    required super.originalLanguage,
    required super.originalTitle,
    required super.overview,
    required super.popularity,
    required super.posterPath,
    required super.releaseDate,
    required super.title,
    required super.video,
    required super.voteAverage,
    required super.voteCount,
    // Parámetros propios de CrewMemberMovie (se inicializan normalmente)
    required this.department,
    required this.job,
  }); // Ya no necesitas la lista de inicializadores explícita para los campos de la superclase

  // El constructor factory no cambia, ya que llama al constructor generativo de esta clase
  factory CrewMemberMovie.fromJson(Map<String, dynamic> json) {
    final String department = json['department'] as String? ?? '';
    final String job = json['job'] as String? ?? '';

    return CrewMemberMovie(
      adult: json["adult"] ?? false,
      backdropPath: json["backdrop_path"] ?? '',
      genreIds: List<int>.from(
        (json["genre_ids"] as List<dynamic>?)?.map((x) => x as int) ?? [],
      ),
      id: json["id"],
      originalLanguage: json["original_language"] ?? '',
      originalTitle: json["original_title"] ?? '',
      overview: json["overview"] ?? '',
      popularity: (json["popularity"] as num?)?.toDouble() ?? 0.0,
      posterPath: json["poster_path"] ?? '',
      releaseDate: DateTime.tryParse(json["release_date"] as String? ?? ''),
      title: json["title"] ?? '',
      video: json["video"] ?? false,
      voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
      voteCount: json["vote_count"] ?? 0,
      // Parámetros propios de CrewMemberMovie
      department: department,
      job: job,
    );
  }
}

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.movieDBKey},
    ),
  );

  void _updateLanguage() {
    dio.options.queryParameters['language'] = GlobalAppState.languageCode;
  }

  List<Movie> _jsonToMovie(Map<String, dynamic> json, {String type = 'Movie'}) {
    List<Movie> movies;
    if (type == 'Movie') {
      final movieDBResponse = MovieDbResponse.fromJson(json);
      movies =
          movieDBResponse.results
              .where((moviedb) => moviedb.posterPath != '')
              .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
              .toList();
    } else {
      final movieDBResponse = List<MovieMovieDB>.from(
        json["cast"].map((x) => MovieMovieDB.fromJson(x)),
      );
      movies =
          movieDBResponse
              .cast()
              .where((moviedb) => moviedb.posterPath != '')
              .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
              .toList();
    }

    movies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return movies;
  }

  List<Video> _jsonToVideo(Map<String, dynamic> json) {
    final videoResponse = VideoResponse.fromJson(json);
    final List<Video> videos =
        videoResponse.results.map(VideoMapper.videoToEntity).toList();
    return videos;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    try {
      _updateLanguage();
      final response = await dio.get(
        '/movie/now_playing',
        queryParameters: {'page': page},
      );
      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    try {
      _updateLanguage();
      final response = await dio.get(
        '/movie/upcoming',
        queryParameters: {'page': page},
      );
      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    try {
      _updateLanguage();
      final response = await dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );
      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    try {
      _updateLanguage();
      final response = await dio.get(
        '/movie/top_rated',
        queryParameters: {'page': page},
      );
      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Movie> getMovieById(String id, {CancelToken? cancelToken}) async {
    try {
      _updateLanguage();
      final response = await dio.get('/movie/$id', cancelToken: cancelToken);
      if (response.statusCode != 200) {
        throw Exception('Movie with id $id not found');
      }

      final movieDetails = MovieDetailsResponse.fromJson(response.data);

      return MovieFromMovieDetailMapper.movieDetailsToMovie(
        movieDetails,
      ); // Mapea a tipo Movie
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MovieDetail> getMovieDetailById(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      _updateLanguage();
      final response = await dio.get('/movie/$id', cancelToken: cancelToken);
      if (response.statusCode != 200) {
        throw Exception('Movie with id $id not found');
      }

      final movieDetails = MovieDetailsResponse.fromJson(response.data);
      return MovieDetailMapper.movieDetailsToEntity(movieDetails);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Video>> getVideosByMovieId(String id) async {
    try {
      _updateLanguage();
      final response = await dio.get('/movie/$id/videos');
      if (response.statusCode != 200) throw Exception();

      List<Video> videos = _jsonToVideo(response.data);

      if (videos.isEmpty) {
        final responseEn = await dio.get(
          '/movie/$id/videos',
          queryParameters: {'language': 'en-US'},
        );
        if (responseEn.statusCode == 200) {
          videos = _jsonToVideo(responseEn.data);
        }
      }

      return videos;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getSimilar(String id, {int page = 1}) async {
    try {
      _updateLanguage();
      final response = await dio.get(
        '/movie/$id/similar',
        queryParameters: {'page': page},
      );
      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getMoviesByGenreId(String id, {int page = 1}) async {
    try {
      _updateLanguage();
      final response = await dio.get(
        '/discover/movie',
        queryParameters: {'with_genres': id, 'page': page},
      );
      return _jsonToMovie(response.data);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getMoviesByPersonId(String id) async {
    try {
      _updateLanguage();
      final response = await dio.get('/person/$id/movie_credits');
      return _jsonToMovie(response.data, type: 'Cast');
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Map<String, List<Movie>>> getMoviesCrewByPersonId(
    String personId,
  ) async {
    _updateLanguage();
    try {
      final response = await dio.get('/person/$personId/movie_credits');
      final Map<String, dynamic> json = response.data;

      Map<String, List<Movie>> groupedCrewMovies = {};
      Set<int> movieIdsAlreadyCategorized = {};

      final List<CrewMemberMovie> crewItems = List<CrewMemberMovie>.from(
        (json["crew"] as List<dynamic>? ?? []).map(
          (x) => CrewMemberMovie.fromJson(x as Map<String, dynamic>),
        ),
      );

      final List<CrewMemberMovie> validCrewItems =
          crewItems.where((crewMember) => crewMember.posterPath != '').toList();

      Map<int, String> movieToHighestPriorityJob = {};
      Map<int, CrewMemberMovie> movieDataMap = {};

      for (var crewMember in validCrewItems) {
        movieDataMap[crewMember.id] = crewMember;
        String? currentHighestJob = movieToHighestPriorityJob[crewMember.id];
        int currentPriority =
            currentHighestJob != null
                ? crewRoleCategories.keys.toList().indexOf(
                  crewRoleCategories.entries
                      .firstWhere(
                        (entry) => entry.value.contains(currentHighestJob),
                        orElse: () => MapEntry('Other Crew Work', []),
                      )
                      .key,
                )
                : 999;

        for (var categoryEntry in crewRoleCategories.entries) {
          if (categoryEntry.value.contains(crewMember.job)) {
            int jobPriority = crewRoleCategories.keys.toList().indexOf(
              categoryEntry.key,
            );
            if (jobPriority < currentPriority) {
              movieToHighestPriorityJob[crewMember.id] = crewMember.job;
              currentPriority = jobPriority;
            }
            break;
          }
        }
        if (!movieToHighestPriorityJob.containsKey(crewMember.id) &&
            crewMember.job.isNotEmpty) {
          movieToHighestPriorityJob[crewMember.id] = crewMember.job;
        }
      }

      final List<String> orderedCategoryTitles =
          crewRoleCategories.keys.toList();

      for (String categoryTitle in orderedCategoryTitles) {
        List<Movie> moviesForThisCategory = [];
        final jobsInThisCategory = crewRoleCategories[categoryTitle]!;

        List<CrewMemberMovie> itemsForThisCategory;

        if (categoryTitle == 'Other Crew Work') {
          itemsForThisCategory =
              validCrewItems.where((item) {
                final assignedJob = movieToHighestPriorityJob[item.id];
                if (assignedJob == null) {
                  return true;
                }

                bool isInOtherCategory = false;
                for (var entry in crewRoleCategories.entries) {
                  if (entry.key != 'Other Crew Work' &&
                      entry.value.contains(assignedJob)) {
                    isInOtherCategory = true;
                    break;
                  }
                }
                return !isInOtherCategory &&
                    !movieIdsAlreadyCategorized.contains(item.id);
              }).toList();
        } else {
          itemsForThisCategory =
              validCrewItems.where((item) {
                final highestJobForMovie = movieToHighestPriorityJob[item.id];
                return highestJobForMovie != null &&
                    jobsInThisCategory.contains(highestJobForMovie) &&
                    !movieIdsAlreadyCategorized.contains(item.id);
              }).toList();
        }

        if (itemsForThisCategory.isNotEmpty) {
          final Map<int, Movie> tempUniqueMovies = {};
          for (var crewMember in itemsForThisCategory) {
            if (!tempUniqueMovies.containsKey(crewMember.id)) {
              final movie = MovieMapper.movieDBToEntity(crewMember);
              tempUniqueMovies[crewMember.id] = movie;
              movieIdsAlreadyCategorized.add(crewMember.id);
            }
          }
          moviesForThisCategory = tempUniqueMovies.values.toList();
          moviesForThisCategory.sort(
            (a, b) => b.voteAverage.compareTo(a.voteAverage),
          );
          if (moviesForThisCategory.isNotEmpty) {
            groupedCrewMovies[categoryTitle] = moviesForThisCategory;
          }
        }
      }
      return groupedCrewMovies;
    } catch (e) {
      return {};
    }
  }
}
