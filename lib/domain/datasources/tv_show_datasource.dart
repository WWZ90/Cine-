import 'package:cinemania/domain/entities/tv_show.dart';

abstract class TvShowDatasource {
  Future<List<TVShow>> getOnTheAir({int page = 1});
  Future<List<TVShow>> getPopular({int page = 1});
  Future<List<TVShow>> getTopRated({int page = 1});
}
