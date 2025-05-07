import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/presentation/providers/tv_shows/tv_shows_provider.dart';

final initialLoadingTVShowProvider = Provider((ref) {
  final step1 = ref.watch(onTheAirTVShowsProvider).shows.isEmpty;
  final step2 = ref.watch(popularTVShowsProvider).shows.isEmpty;
  final step3 = ref.watch(topRatedTVShowsProvider).shows.isEmpty;

  if (step1 || step2 || step3) return true;

  return false;
});
