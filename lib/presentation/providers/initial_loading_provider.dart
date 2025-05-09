import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/presentation/providers/providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(nowPlayingMoviesProvider).movies.isEmpty;
  final step2 = ref.watch(upcomingMoviesProvider).movies.isEmpty;
  final step3 = ref.watch(popularMoviesProvider).movies.isEmpty;
  final step4 = ref.watch(topRatedMoviesProvider).movies.isEmpty;
  final step5 = ref.watch(genresMovieProvider).isEmpty;
  final step6 = ref.watch(airingTodayTVShowsProvider).shows.isEmpty;
  final step7 = ref.watch(onTheAirTVShowsProvider).shows.isEmpty;
  final step8 = ref.watch(popularTVShowsProvider).shows.isEmpty;
  final step9 = ref.watch(topRatedTVShowsProvider).shows.isEmpty;
  final step10 = ref.watch(genresTVShowProvider).isEmpty;
  final step11 = ref.watch(personPopularProvider).isEmpty;
  //final step12 = ref.watch(personTrendingProvider).isEmpty;
  //final step11 = ref.watch(favoritesProvider).isEmpty;

  final curatedActors = ref.watch(curatedActorsProvider);

  final step12 = curatedActors.maybeWhen(
    data: (actors) => actors.isEmpty,
    orElse: () => true,
  );

  if (step1 ||
      step2 ||
      step3 ||
      step4 ||
      step5 ||
      step6 ||
      step7 ||
      step8 ||
      step9 ||
      step10 ||
      step11 ||
      step12) {
    return true;
  }

  return false;
});
