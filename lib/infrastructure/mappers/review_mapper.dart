import 'package:cinemania/domain/entities/review.dart';
import 'package:cinemania/infrastructure/models/moviedb/reviews_response.dart';

import 'author_detail_mapper.dart';

class ReviewMapper {
  static Review reviewToEntity(ReviewsDB review) => Review(
    id: review.id,
    author: review.author,
    authorDetails: AuthorDetailsMapper.fromResponse(review.authorDetails),
    content: review.content,
    createdAt: review.createdAt,
  );
}
