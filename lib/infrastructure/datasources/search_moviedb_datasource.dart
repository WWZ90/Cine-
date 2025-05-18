import 'package:cinemania/config/global_app_state.dart';
import 'package:dio/dio.dart';
import 'package:cinemania/domain/entities/search.dart';
import 'package:cinemania/infrastructure/models/moviedb/searchs_response.dart';
import 'package:cinemania/domain/datasources/searchs_datasource.dart';
import 'package:cinemania/infrastructure/mappers/search_mapper.dart';
import 'package:cinemania/config/constants/environment.dart';

class SearchMoviedbDatasource extends SearchsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.movieDBKey},
    ),
  );

  void _updateLanguage() {
    dio.options.queryParameters['language'] = GlobalAppState.languageCode;
  }

  @override
  Future<List<MultiSearch>> multiSearch(String query) async {
    if (query.isEmpty) return [];

    _updateLanguage();
    final response = await dio.get(
      '/search/multi',
      queryParameters: {'query': query},
    );

    if (response.statusCode != 200) {
      throw Exception('An error occours');
    }

    final searchResponse = SearchResponse.fromJson(response.data);

    List<MultiSearch> searchs =
        searchResponse.results
            .map((info) => SearchMapper.searchToEntity(info))
            .toList();

    return searchs;
  }
}
