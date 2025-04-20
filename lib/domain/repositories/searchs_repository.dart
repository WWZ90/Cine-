import 'package:cinemania/domain/entities/search.dart';

abstract class SearchsRepository {
  Future<List<MultiSearch>> multiSearch(String query);
}
