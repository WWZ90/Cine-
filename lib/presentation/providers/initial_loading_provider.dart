import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final step2 = ref.watch(upcomingMoviesProvider).isEmpty;
  final step3 = ref.watch(popularMoviesProvider).isEmpty;
  final step4 = ref.watch(topRatedMoviesProvider).isEmpty;
  final step5 = ref.watch(genresMovieProvider).isEmpty;
  final step6 = ref.watch(airingTodayTVShowsProvider).isEmpty;
  final step7 = ref.watch(onTheAirTVShowsProvider).isEmpty;
  final step8 = ref.watch(popularTVShowsProvider).isEmpty;
  final step9 = ref.watch(topRatedTVShowsProvider).isEmpty;
  final step10 = ref.watch(genresTVShowProvider).isEmpty;

  if (step1 || step2 || step3 || step4 || step5 || step6 || step7 || step8 || step9 || step10) return true;

  return false;
});
