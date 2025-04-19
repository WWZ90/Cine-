import 'package:cinemania/infrastructure/datasources/review_moviedb_datasource.dart';
import 'package:cinemania/infrastructure/repositories/review_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewsRepositoryProvider = Provider((ref) {
  return ReviewRepositoryImpl(ReviewMovieDbDatasource());
});
