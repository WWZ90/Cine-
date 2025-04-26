import 'package:cinemania/domain/entities/entities.dart';

abstract class SearchsRepository {
  Future<List<MultiSearch>> multiSearch(String query);
}
