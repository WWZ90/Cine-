import 'package:dio/dio.dart';
import 'package:cinemania/config/global_app_state.dart';
import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/datasources/tv_show_datasource.dart';
import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/domain/entities/tv_show_details.dart';
import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/infrastructure/mappers/tv_show_detail_mapper.dart';
import 'package:cinemania/infrastructure/mappers/tv_show_mapper.dart';
import 'package:cinemania/infrastructure/mappers/video_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/tvshow_details.dart';
import 'package:cinemania/infrastructure/models/moviedb/tvshow_moviedb.dart';
import 'package:cinemania/infrastructure/models/moviedb/tvshow_response.dart';
import 'package:cinemania/infrastructure/models/video/video_response.dart';

class TvShowMoviedbDatasource extends TvShowDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.movieDBKey},
    ),
  );

  void _updateLanguage() {
    dio.options.queryParameters['language'] = GlobalAppState.languageCode;
  }

  List<TVShow> _jsonToTVShow(
    Map<String, dynamic> json, {
    String type = 'TVShow',
  }) {
    List<TVShow> tvShows;
    if (type == 'TVShow') {
      final tvShowResponse = TvShowResponse.fromJson(json);
      tvShows =
          tvShowResponse.results
              .where((tvShow) => tvShow.posterPath != '')
              .map((tvShow) => TvShowMapper.tvShowToEntity(tvShow))
              .toList();
    } else {
      if (json["cast"] == null) {
        return [];
      }

      final List<dynamic> tvCreditsJson = json["cast"] as List<dynamic>;

      final Map<int, TVShow> uniqueTVShowsMap = {};

      for (var creditJsonMap in tvCreditsJson) {
        final tvShowDBInstance = TVShowDB.fromJson(
          creditJsonMap as Map<String, dynamic>,
        );

        if (tvShowDBInstance.posterPath != '' &&
            tvShowDBInstance.posterPath.isNotEmpty) {
          if (!uniqueTVShowsMap.containsKey(tvShowDBInstance.id)) {
            uniqueTVShowsMap[tvShowDBInstance.id] = TvShowMapper.tvShowToEntity(
              tvShowDBInstance,
            );
          }
        }
      }
      tvShows = uniqueTVShowsMap.values.toList();
    }

    tvShows.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return tvShows;
  }

  List<Video> _jsonToVideo(Map<String, dynamic> json) {
    final videoResponse = VideoResponse.fromJson(json);
    return videoResponse.results.map(VideoMapper.videoToEntity).toList();
  }

  @override
  Future<List<TVShow>> getAiringToday({int page = 1}) async {
    try {
      _updateLanguage();
      final response = await dio.get(
        '/tv/airing_today',
        queryParameters: {'page': page},
      );
      return _jsonToTVShow(response.data);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<TVShow>> getOnTheAir({int page = 1}) async {
    try {
      _updateLanguage();
      final response = await dio.get(
        '/tv/on_the_air',
        queryParameters: {'page': page},
      );
      return _jsonToTVShow(response.data);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<TVShow>> getPopular({int page = 1}) async {
    try {
      _updateLanguage();
      final response = await dio.get(
        '/tv/popular',
        queryParameters: {'page': page},
      );
      return _jsonToTVShow(response.data);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<TVShow>> getTopRated({int page = 1}) async {
    try {
      _updateLanguage();
      final response = await dio.get(
        '/tv/top_rated',
        queryParameters: {'page': page},
      );
      return _jsonToTVShow(response.data);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<TvShowDetails> getTVShowById(String id) async {
    _updateLanguage();
    final response = await dio.get('/tv/$id');
    if (response.statusCode != 200) {
      throw Exception('No TVShow found for this id $id');
    }

    final tvShowDetailsR = TvShowDetailsResponse.fromJson(response.data);
    return TvShowDetailMapper.tvShowDetailsToEntity(tvShowDetailsR);
  }

  @override
  Future<List<Video>> getVideosByTVShowId(String id) async {
    try {
      _updateLanguage();
      final response = await dio.get('/tv/$id/videos');
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
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<TVShow>> getTVShowByGenreId(String id, {int page = 1}) async {
    _updateLanguage();
    final response = await dio.get(
      '/discover/tv',
      queryParameters: {'with_genres': id, 'page': page},
    );
    return _jsonToTVShow(response.data);
  }

  @override
  Future<List<TVShow>> getSimilar(String id, {int page = 1}) async {
    _updateLanguage();
    final response = await dio.get(
      '/tv/$id/similar',
      queryParameters: {'page': page},
    );
    return _jsonToTVShow(response.data);
  }

  @override
  Future<List<TVShow>> getTVShowByPersonId(String id) async {
    _updateLanguage();
    final response = await dio.get('/person/$id/tv_credits');
    return _jsonToTVShow(response.data, type: 'Cast');
  }
}
