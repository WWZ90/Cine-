import 'package:cinemania/domain/entities/entities.dart';

abstract class ReviewsRepository {
  Future<List<Review>> getReviewsByMovieId(String id, {int page = 1});
}