import 'package:cinemania/domain/datasources/tv_show_datasource.dart';
import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/domain/repositories/tv_show_repository.dart';

class TvShowRepositoryImpl extends TvShowRepository {
  final TvShowDatasource datasource;

  TvShowRepositoryImpl(this.datasource);

  @override
  Future<List<TVShow>> getOnTheAir({int page = 1}) {
    return datasource.getOnTheAir();
  }

  @override
  Future<List<TVShow>> getPopular({int page = 1}) {
    return datasource.getPopular();
  }

  @override
  Future<List<TVShow>> getTopRated({int page = 1}) {
    return datasource.getTopRated();
  }
}
