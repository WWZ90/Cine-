import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/datasources/reviews_datasource.dart';
import 'package:cinemania/domain/entities/review.dart';
import 'package:cinemania/infrastructure/mappers/review_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/reviews_response.dart';
import 'package:dio/dio.dart';

class ReviewMovieDbDatasource extends ReviewsDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.movieDBKey, 'language': 'en-EN'},
    ),
  );

  @override
  Future<List<Review>> getReviewsByMovieId(String id, {int page = 1}) async {
    final response = await dio.get('/movie/$id/reviews');

    if (response.statusCode != 200) {
      throw Exception('Reviews for movieId $id not found');
    }

    final reviewResponse = ReviewsResponse.fromJson(response.data);
    List<Review> reviews =
        reviewResponse.results
            .map((review) => ReviewMapper.reviewToEntity(review))
            .toList();
    return reviews;
  }
}
