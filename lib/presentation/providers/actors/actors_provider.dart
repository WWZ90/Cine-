import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/actors/actors_repository_provider.dart';

final actorsByMovieProvider =
    StateNotifierProvider<ActorNotifier, Map<String, List<Actor>>>((ref) {
      final actorsRepository = ref.watch(actorsRepositoryProvider);
      return ActorNotifier(getActors: actorsRepository.getActorsByMovie);
    });

final actorsByTVShowProvider =
    StateNotifierProvider<ActorNotifier, Map<String, List<Actor>>>((ref) {
      final actorsRepository = ref.watch(actorsRepositoryProvider);
      return ActorNotifier(getActors: actorsRepository.getActorsByTVShow);
    });

typedef GetActorsByMovieCallback = Future<List<Actor>> Function(String id);

class ActorNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsByMovieCallback getActors;
  ActorNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String id) async {
    if (state[id] != null) return;

    final List<Actor> actors = await getActors(id);

    state = {...state, id: actors};
  }
}
