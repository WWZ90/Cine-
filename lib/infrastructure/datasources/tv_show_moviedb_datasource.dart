import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/datasources/tv_show_datasource.dart';
import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/domain/entities/tv_show_details.dart';
import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/infrastructure/mappers/tv_show_detail_mapper.dart';
import 'package:cinemania/infrastructure/mappers/tv_show_mapper.dart';
import 'package:cinemania/infrastructure/mappers/video_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/tvshow_details.dart';
import 'package:cinemania/infrastructure/models/moviedb/tvshow_response.dart';
import 'package:cinemania/infrastructure/models/video/video_response.dart';
import 'package:dio/dio.dart';

class TvShowMoviedbDatasource extends TvShowDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.movieDBKey, 'language': 'es-ES'},
    ),
  );

  List<TVShow> _jsonToTVShow(Map<String, dynamic> json) {
    final tvShowResponse = TvShowResponse.fromJson(json);
    final List<TVShow> tvShows =
        tvShowResponse.results
            .map((tvShow) => TvShowMapper.tvShowToEntity(tvShow))
            .toList();

    return tvShows;
  }

  List<Video> _jsonToVideo(Map<String, dynamic> json) {
    final videoResponse = VideoResponse.fromJson(json);
    final List<Video> videos =
        videoResponse.results
            .map((video) => VideoMapper.videoToEntity(video))
            .toList();
    return videos;
  }

  @override
  Future<List<TVShow>> getAiringToday({int page = 1}) async {
    final response = await dio.get(
      '/tv/airing_today',
      queryParameters: {'page': page},
    );

    return _jsonToTVShow(response.data);
  }

  @override
  Future<List<TVShow>> getOnTheAir({int page = 1}) async {
    final response = await dio.get(
      '/tv/on_the_air',
      queryParameters: {'page': page},
    );

    return _jsonToTVShow(response.data);
  }

  @override
  Future<List<TVShow>> getPopular({int page = 1}) async {
    final response = await dio.get(
      '/tv/popular',
      queryParameters: {'page': page},
    );

    return _jsonToTVShow(response.data);
  }

  @override
  Future<List<TVShow>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/tv/top_rated',
      queryParameters: {'page': page},
    );

    return _jsonToTVShow(response.data);
  }

  @override
  Future<TvShowDetails> getTVShowById(String id) async {
    final response = await dio.get('/tv/$id');

    if (response.statusCode != 200) {
      throw Exception('No TVShow found for this id $id');
    }

    final tvShowDetailsR = TvShowDetailsResponse.fromJson(response.data);

    final TvShowDetails tvShowDetails =
        TvShowDetailMapper.tvShowDetailsToEntity(tvShowDetailsR);

    return tvShowDetails;
  }

  @override
  Future<List<Video>> getVideosByTVShowId(String id) async {
    final response = await dio.get('/tv/$id/videos');

    if (response.statusCode != 200) {
      throw Exception('TVShow with id $id not found');
    }

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
  }
  
  @override
  Future<List<TVShow>> getTVShowByGenreId(String id, {int page = 1}) async {
    final response = await dio.get(
      '/discover/tv',
      queryParameters: {'with_genres': id, 'page': page},
    );
    return _jsonToTVShow(response.data);
  }
}
