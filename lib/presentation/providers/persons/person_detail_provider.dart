import 'package:cinemania/domain/repositories/persons_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/persons/persons_repository_provider.dart';

// final personDetailsProvider = 
//     StateNotifierProvider.family<PersonDetailsNotifier, AsyncValue<PersonDetails>, int>((ref, personId) {
//   final repository = ref.read(personsRepositoryProvider);
//   return PersonDetailsNotifier(repository: repository, personId: personId);
// });

// class PersonDetailsNotifier extends StateNotifier<AsyncValue<PersonDetails>> {
//   final int personId;
//   final PersonRepository repository;

//   PersonDetailsNotifier({required this.repository, required this.personId})
//       : super(const AsyncLoading()) {
//     loadPersonDetails();
//   }

//   Future<void> loadPersonDetails() async {
//     try {
//       final person = await repository.getPersonDetails(personId.toString());
//       state = AsyncValue.data(person);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }
// }


final personDetailProvider =
    StateNotifierProvider<PersonMapNotifier, Map<String, PersonDetails>>((ref) {
      final personRepository = ref.watch(personsRepositoryProvider);
      return PersonMapNotifier(
        getPerson:
            (id) =>
                personRepository.getPersonDetails(id),
      );
    });

typedef GetPersonCallback =
    Future<PersonDetails> Function(String personId);

class PersonMapNotifier extends StateNotifier<Map<String, PersonDetails>> {
  final GetPersonCallback getPerson;
  PersonMapNotifier({required this.getPerson}) : super({});

  Future<void> loadPerson(String personId) async {
    try {
      if (state[personId] != null) return;

      final person = await getPerson(personId);

      state = {...state, personId: person};
    } catch (e) {
      throw Exception('Person with id $personId not found');
    }
  }
}
