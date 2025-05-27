import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';
import 'package:cinemania/presentation/providers/providers.dart';

typedef PersonsCallback = Future<List<Person>> Function({int page});

class PersonState {
  final List<Person> persons;
  final bool isLoading;

  PersonState({required this.persons, required this.isLoading});

  PersonState copyWith({List<Person>? persons, bool? isLoading}) {
    return PersonState(
      persons: persons ?? this.persons,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// class PersonNotifier extends StateNotifier<List<Person>> {
//   int currentPage = 0;
//   bool isLoading = false;
//   bool _initialized = false;
//   final PersonsCallback fetchPersons;

//   PersonNotifier({required this.fetchPersons}) : super([]);

//   Future<void> loadNextPage() async {
//     if (isLoading || _initialized) return;
//     isLoading = true;
//     currentPage++;

//     final List<Person> persons = await fetchPersons(page: currentPage);
//     state = [...state, ...persons];

//     _initialized = true;
//     await Future.delayed(Duration(milliseconds: 400));
//     isLoading = false;
//   }
// }

// class PersonNotifier extends StateNotifier<PersonState> {
//   final Future<List<Person>> Function({int page}) fetchPersons;
//   int currentPage = 0;

//   PersonNotifier({required this.fetchPersons})
//     : super(PersonState(persons: [], isLoading: false)) {
//     loadNextPage();
//   }

//   Future<void> loadNextPage() async {
//     if (state.isLoading) return;

//     state = state.copyWith(isLoading: true);
//     currentPage++;

//     final newPersons = await fetchPersons(page: currentPage);
//     state = state.copyWith(
//       persons: [...state.persons, ...newPersons],
//       isLoading: false,
//     );
//   }

//   Future<void> reset() async {
//     currentPage = 0;
//     state = PersonState(persons: [], isLoading: false);
//     await loadNextPage();
//   }
// }

class PersonNotifier extends StateNotifier<PersonState> {
  int currentPage = 0;
  final PersonsCallback fetchPersons;

  PersonNotifier({required this.fetchPersons})
    : super(PersonState(persons: [], isLoading: false));

  Future<void> loadNextPage() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    currentPage++;

    final List<Person> persons = await fetchPersons(page: currentPage);
    state = PersonState(persons: [...state.persons, ...persons], isLoading: false);
  }

  Future<void> reset() async {
    currentPage = 0;
    state = PersonState(persons: [], isLoading: false);
    await loadNextPage();
  }
}

final personTrendingProvider =
    StateNotifierProvider<PersonNotifier, PersonState>((ref) {
      //ref.keepAlive();
      final personRepository =
          ref.watch(personsRepositoryProvider).getPersonTrending;
      return PersonNotifier(fetchPersons: personRepository);
    });

final personPopularProvider =
    StateNotifierProvider<PersonNotifier, PersonState>((ref) {
      //ref.keepAlive();
      final personsRepository =
          ref.watch(personsRepositoryProvider).getPersonPopular;
      return PersonNotifier(fetchPersons: personsRepository);
    });

final curatedActorsProvider = FutureProvider<List<Person>>((ref) async {
  final personsRepo = ref.read(personsRepositoryProvider);

  // Espera activa hasta que popularMoviesProvider tenga datos
  List<Movie> popularMovies = [];

  while (popularMovies.isEmpty) {
    await Future.delayed(const Duration(milliseconds: 100));
    final state = ref.read(popularMoviesProvider);
    popularMovies = state.movies;
  }

  final Set<int> addedPersonIds = {};
  final List<Person> curatedActors = [];

  for (final movie in popularMovies.take(10)) {
    final credits = await personsRepo.getCastByMovie(movie.id.toString());

    for (final castPerson in credits.cast().take(5)) {
      if (castPerson.profilePath != null &&
          !addedPersonIds.contains(castPerson.id)) {
        final person = Person(
          id: castPerson.id,
          name: castPerson.name,
          originalName: castPerson.name,
          profilePath: castPerson.profilePath,
          knownForDepartment: KnownForDepartment.ACTING,
          popularity: 0,
          gender: 0,
          adult: false,
          mediaType: MediaType.PERSON,
        );
        curatedActors.add(person);
        addedPersonIds.add(person.id);
      }
    }
  }

  return curatedActors;
});

final personProvider = FutureProvider.family<Person?, ({int personId})>((
  ref,
  params,
) async {
  final datasource = ref.watch(personsRepositoryProvider);
  return await datasource.getPersonById(params.personId.toString());
});
