import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';

final reviewsByMovieProvider = FutureProvider.family<List<Review>, String>((
  ref,
  id,
) async {
  final reviewsRepository =
      ref.watch(reviewsRepositoryProvider).getReviewsByMovieId;

  final reviews = await reviewsRepository(id);

  return reviews;
});

final reviewsByTVShowProvider = FutureProvider.family<List<Review>, String>((
  ref,
  id,
) async {
  final reviewsRepository =
      ref.read(reviewsRepositoryProvider).getReviewsByTVShowId;

  final reviews = await reviewsRepository(id);

  return reviews;
});
