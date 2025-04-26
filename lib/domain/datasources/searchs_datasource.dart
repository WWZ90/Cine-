import 'package:cinemania/domain/entities/entities.dart';

abstract class SearchsDatasource {
  Future<List<MultiSearch>> multiSearch(String query);
}
