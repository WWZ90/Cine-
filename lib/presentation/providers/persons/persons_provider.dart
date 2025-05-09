import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/infrastructure/mappers/person_mapper.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personTrendingProvider =
    StateNotifierProvider<PersonNotifier, List<Person>>((ref) {
      final personRepository =
          ref.watch(personsRepositoryProvider).getPersonTrending;
      return PersonNotifier(fetchPersons: personRepository);
    });

final personPopularProvider =
    StateNotifierProvider<PersonNotifier, List<Person>>((ref) {
      final personsRepository =
          ref.watch(personsRepositoryProvider).getPersonPopular;
      return PersonNotifier(fetchPersons: personsRepository);
    });

final curatedActorsProvider = FutureProvider<List<Person>>((ref) async {
  final personsRepo = ref.read(personsRepositoryProvider);
  final popularMoviesState = ref.watch(popularMoviesProvider);

  final Set<int> addedPersonIds = {};
  final List<Person> curatedActors = [];

  for (final movie in popularMoviesState.movies.take(10)) {
    final credits = await personsRepo.getCastByMovie(movie.id.toString());

    for (final castPerson in credits.cast().take(5)) {
      if (castPerson.profilePath != null &&
          !addedPersonIds.contains(castPerson.id)) {
        //final person = PersonMapper.personToEntity(castPerson);
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

typedef PersonsCallback = Future<List<Person>> Function({int page});

class PersonNotifier extends StateNotifier<List<Person>> {
  int currentPage = 0;
  bool isLoading = false;
  final PersonsCallback fetchPersons;
  PersonNotifier({required this.fetchPersons}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;

    currentPage++;

    print('Loading new Persons');

    final List<Person> persons = await fetchPersons(page: currentPage);

    state = [...state, ...persons];
    await Future.delayed(Duration(milliseconds: 400));
    isLoading = false;
  }
}
