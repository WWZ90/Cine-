import 'package:cinemania/domain/datasources/searchs_datasource.dart';
import 'package:cinemania/domain/entities/search.dart';
import 'package:cinemania/domain/repositories/searchs_repository.dart';

class SearchRepositoryImpl extends SearchsRepository {
  final SearchsDatasource datasource;

  SearchRepositoryImpl(this.datasource);

  @override
  Future<List<MultiSearch>> multiSearch(String query) {
    return datasource.multiSearch(query);
  }
}
