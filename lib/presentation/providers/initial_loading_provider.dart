import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/presentation/providers/providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(
    nowPlayingMoviesProvider.select((s) => s.movies.isEmpty),
  );
  final step2 = ref.watch(
    upcomingMoviesProvider.select((s) => s.movies.isEmpty),
  );
  final step3 = ref.watch(
    popularMoviesProvider.select((s) => s.movies.isEmpty),
  );
  final step4 = ref.watch(
    topRatedMoviesProvider.select((s) => s.movies.isEmpty),
  );
  final step5 = ref.watch(genresMovieProvider.select((s) => s.isEmpty));
  final step6 = ref.watch(
    airingTodayTVShowsProvider.select((s) => s.shows.isEmpty),
  );
  final step7 = ref.watch(
    onTheAirTVShowsProvider.select((s) => s.shows.isEmpty),
  );
  final step8 = ref.watch(
    popularTVShowsProvider.select((s) => s.shows.isEmpty),
  );
  final step9 = ref.watch(
    topRatedTVShowsProvider.select((s) => s.shows.isEmpty),
  );
  final step10 = ref.watch(genresTVShowProvider.select((s) => s.isEmpty));
  final step11 = ref.watch(personPopularProvider.select((s) => s.persons.isEmpty));

  /*
  final curatedActors = ref.watch(curatedActorsProvider);

  final step12 = curatedActors.maybeWhen(
    data: (actors) => actors.isEmpty,
    orElse: () => true,
  );
*/

  return step1 ||
      step2 ||
      step3 ||
      step4 ||
      step5 ||
      step6 ||
      step7 ||
      step8 ||
      step9 ||
      step10 ||
      step11;
});
