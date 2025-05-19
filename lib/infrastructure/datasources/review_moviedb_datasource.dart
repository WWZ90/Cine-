import 'package:cinemania/config/global_app_state.dart';
import 'package:dio/dio.dart';
import 'package:cinemania/domain/entities/review.dart';
import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/domain/datasources/reviews_datasource.dart';
import 'package:cinemania/infrastructure/mappers/review_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/reviews_response.dart';
import 'package:translator/translator.dart';

class ReviewMovieDbDatasource extends ReviewsDatasource {
  final _translator = GoogleTranslator();

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

    // Si el idioma es español, traducí el contenido
    if (GlobalAppState.languageCode == 'es-ES') {
      reviews = await _translateReviews(reviews, to: 'es');
    }

    return reviews;
  }

  @override
  Future<List<Review>> getReviewsByTVShowId(String id, {int page = 1}) async {
    final response = await dio.get('/tv/$id/reviews');

    if (response.statusCode != 200) {
      throw Exception('Reviews for tvShowId $id not found');
    }

    final reviewsResponse = ReviewsResponse.fromJson(response.data);

    List<Review> reviews =
        reviewsResponse.results
            .map((review) => ReviewMapper.reviewToEntity(review))
            .toList();

    // Si el idioma es español, traducí el contenido
    if (GlobalAppState.languageCode == 'es-ES') {
      reviews = await _translateReviews(reviews, to: 'es');
    }

    return reviews;
  }

  Future<List<Review>> _translateReviews(
    List<Review> reviews, {
    required String to,
  }) async {
    return Future.wait(
      reviews.map((review) async {
        final translatedContent = await _translator.translate(
          review.content,
          to: to,
        );

        return review.copyWith(content: translatedContent.text);
      }),
    );
  }
}
