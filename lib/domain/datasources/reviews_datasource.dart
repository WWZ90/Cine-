import 'package:cinemania/domain/entities/review.dart';

abstract class ReviewsDatasource {
    Future<List<Review>> getReviewsByMovieId(String id, {int page = 1});
}