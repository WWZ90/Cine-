import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/persons/persons_repository_provider.dart';

final castByMovieProvider =
    StateNotifierProvider<CastNotifier, Map<String, List<CastPerson>>>((ref) {
      final actorsRepository = ref.watch(personsRepositoryProvider);
      return CastNotifier(getActors: actorsRepository.getCastByMovie);
    });

final castByTVShowProvider =
    StateNotifierProvider<CastNotifier, Map<String, List<CastPerson>>>((ref) {
      final actorsRepository = ref.watch(personsRepositoryProvider);
      return CastNotifier(getActors: actorsRepository.getCastByTVShow);
    });

typedef GetActorsByMovieCallback = Future<List<CastPerson>> Function(String id);

class CastNotifier extends StateNotifier<Map<String, List<CastPerson>>> {
  final GetActorsByMovieCallback getActors;
  CastNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String id) async {
    if (state[id] != null) return;

    final List<CastPerson> actors = await getActors(id);

    state = {...state, id: actors};
  }
}
