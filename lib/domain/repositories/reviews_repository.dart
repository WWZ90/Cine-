import 'package:cinemania/domain/entities/review.dart';

abstract class ReviewsRepository {
  Future<List<Review>> getReviewsByMovieId(String id, {int page = 1});
}