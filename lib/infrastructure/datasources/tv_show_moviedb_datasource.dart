import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/datasources/tv_show_datasource.dart';
import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/infrastructure/mappers/tv_show_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/tvshow_response.dart';
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

  @override
  Future<List<TVShow>> getOnTheAir({int page = 1}) async {
    final response = await dio.get(
      '/tv/on_the_air',
      queryParameters: {'page': page},
    );

    return _jsonToTVShow(response.data);
  }

  @override
  Future<List<TVShow>> getPopular({int page = 1}) async{
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
}
