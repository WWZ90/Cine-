import 'package:cinemania/presentation/providers/tv_shows/tv_shows_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialLoadingTVShowProvider = Provider((ref) {
  final step1 = ref.watch(onTheAirTVShowsProvider).isEmpty;
  final step2 = ref.watch(popularTVShowsProvider).isEmpty;
  final step3 = ref.watch(topRatedTVShowsProvider).isEmpty;

  if (step1 || step2 || step3) return true;

  return false;
});
