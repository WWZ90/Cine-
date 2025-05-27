import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/infrastructure/models/moviedb/oscars/oscars_model.dart';

class PaginatedCeremoniesState {
  final List<Ceremony> ceremonies;
  final bool isLoadingMore;
  final bool hasMore;
  final int nextPageOffset;

  PaginatedCeremoniesState({
    this.ceremonies = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
    this.nextPageOffset = 0,
  });

  PaginatedCeremoniesState copyWith({
    List<Ceremony>? ceremonies,
    bool? isLoadingMore,
    bool? hasMore,
    int? nextPageOffset,
  }) {
    return PaginatedCeremoniesState(
      ceremonies: ceremonies ?? this.ceremonies,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      nextPageOffset: nextPageOffset ?? this.nextPageOffset,
    );
  }
}

class OscarsCeremoniesNotifier extends StateNotifier<PaginatedCeremoniesState> {
  final Ref ref;
  List<Ceremony> _allCeremonies = [];

  OscarsCeremoniesNotifier(this.ref) : super(PaginatedCeremoniesState()) {
    _loadInitialCeremonies();
  }

  Future<void> _loadInitialCeremonies() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/oscars/oscar_ceremonies_ordered.json',
      );
      final allParsedCeremonies = parseCeremonies(jsonString);
      _allCeremonies =
          allParsedCeremonies.reversed.toList(); // Más recientes primero

      state = PaginatedCeremoniesState(
        ceremonies: _allCeremonies,
        hasMore: false,
        isLoadingMore: false,
        nextPageOffset: _allCeremonies.length,
      );
    } catch (e) {
      state = state.copyWith(hasMore: false, isLoadingMore: false);
    }
  }
}

final oscarsCeremoniesProvider =
    StateNotifierProvider<OscarsCeremoniesNotifier, PaginatedCeremoniesState>((
      ref,
    ) {
      return OscarsCeremoniesNotifier(ref);
    });

String generateNomineeIdsKey(List<Nominee> nominees) {
  if (nominees.isEmpty) return "no_nominees";
  // Ordenar para que el orden no afecte la clave
  List<String> ids = nominees.map((n) => n.tmdbId.toString()).toList();
  ids.sort();
  return ids.join(',');
}

final nonWinnerMoviesProvider = FutureProvider.family<
  List<Movie>,
  ({String key, List<Nominee> nominees})
>((ref, params) async {
  final List<Nominee> nonWinnerNominees = params.nominees;
  if (nonWinnerNominees.isEmpty) {
    return [];
  }

  final List<Movie> movies = [];

  final List<Future<Movie?>> movieFutures =
      nonWinnerNominees.map((nominee) {
        return ref.read(movieProvider((movieId: nominee.tmdbId!)).future);
      }).toList();

  final List<Movie?> resolvedMovies = await Future.wait(movieFutures);

  for (final movie in resolvedMovies) {
    if (movie != null) {
      movies.add(movie);
    } else {
    }
  }

  movies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));

  return movies;
});

final nonWinnerPersonsProvider = FutureProvider.family<
  List<Person>,
  ({String key, List<Nominee> nominees})
>((ref, params) async {
  final List<Nominee> nonWinnerNominees = params.nominees;
  if (nonWinnerNominees.isEmpty) {
    return [];
  }

  final List<Person> persons = [];

  final List<Future<Person?>> personFutures =
      nonWinnerNominees.map((nominee) {
        return ref.read(personProvider((personId: nominee.tmdbId!)).future);
      }).toList();

  final List<Person?> resolvedPersons = await Future.wait(personFutures);

  for (final person in resolvedPersons) {
    if (person != null) {
      persons.add(person);
    } else {
    }
  }

  persons.sort((a, b) => b.popularity.compareTo(a.popularity));

  return persons;
});

