import 'package:cinemania/domain/datasources/genres_datasource.dart';
import 'package:cinemania/domain/entities/genre.dart';
import 'package:cinemania/domain/repositories/genres_repository.dart';

class GenreRepositoryImpl extends GenresRepository {
  final GenresDatasource datasource;

  GenreRepositoryImpl(this.datasource);

  @override
  Future<List<Genre>> getGenresMovie() {
    return datasource.getGenresMovie();
  }
}
