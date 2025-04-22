import 'package:cinemania/domain/entities/tv_show_details.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tvShowDetailsProvider =
    StateNotifierProvider<TvShowDetailNotifier, Map<String, TvShowDetails>>((
      ref,
    ) {
      final tvShowRepository = ref.watch(tvShowRepositoryProvider);
      return TvShowDetailNotifier(
        getTVShow: (tvShowId) => tvShowRepository.getTVShowById(tvShowId),
      );
    });

typedef GetTVShowCallback = Future<TvShowDetails> Function(String tvShowId);

class TvShowDetailNotifier extends StateNotifier<Map<String, TvShowDetails>> {
  TvShowDetailNotifier({required this.getTVShow}) : super({});

  final GetTVShowCallback getTVShow;

  Future<void> loadTVShow(String tvShowId) async {
    if (state[tvShowId] != null) return;

    final tvShow = await getTVShow(tvShowId);

    state = {...state, tvShowId: tvShow};
  }
}
