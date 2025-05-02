import 'package:cinemania/domain/datasources/reviews_datasource.dart';
import 'package:cinemania/domain/entities/review.dart';
import 'package:cinemania/domain/repositories/reviews_repository.dart';

class ReviewRepositoryImpl extends ReviewsRepository {
  final ReviewsDatasource datasource;

  ReviewRepositoryImpl(this.datasource);

  @override
  Future<List<Review>> getReviewsByMovieId(String id, {int page = 1}) {
    return datasource.getReviewsByMovieId(id, page: page);
  }

  @override
  Future<List<Review>> getReviewsByTVShowId(String id, {int page = 1}) {
    return datasource.getReviewsByTVShowId(id, page: page);
  }
}
