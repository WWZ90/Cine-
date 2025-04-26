import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';

final reviewsByMovieProvider = StateNotifierProvider.family<ReviewsNotifier, List<Review>, String>((ref, movieId) {
  fetchMoreReviews({int page = 1}) => ref.read(reviewsRepositoryProvider).getReviewsByMovieId(movieId, page: page);

  return ReviewsNotifier(fetchMoreReviews: fetchMoreReviews);
});

typedef ReviewsCallBack = Future<List<Review>> Function({int page});

class ReviewsNotifier extends StateNotifier<List<Review>> {
  int currentPage = 0;
  bool isLoading = false;

  ReviewsCallBack fetchMoreReviews;

  ReviewsNotifier({required this.fetchMoreReviews}): super([]);

  Future<void> loadNextPage() async{
    if(isLoading) return;
    isLoading = true;
    currentPage++;
    print('Loading new reviews');

    final List<Review> reviews = await fetchMoreReviews(page: currentPage);

    state = [...state, ...reviews];
    await Future.delayed(Duration(milliseconds: 400));
    isLoading = false;
  }
  
}