import 'package:cinemania/domain/entities/entities.dart';
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
