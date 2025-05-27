import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/infrastructure/models/moviedb/oscars/oscars_model.dart';

class OscarMovieWinnerCard extends ConsumerWidget {
  final Nominee winnerNominee;

  const OscarMovieWinnerCard({super.key, required this.winnerNominee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final movieAsync = ref.watch(
      movieProvider((movieId: winnerNominee.tmdbId!)),
    );

    return movieAsync.when(
      data: (movie) {
        if (movie == null) {
          return Card(
            // Tarjeta de error si la película no se encuentra
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${l10n.errorLoadingMovie}: ${winnerNominee.title} (ID: ${winnerNominee.tmdbId})',
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            context.pushNamed(MovieScreen.name, extra: movie);
          },
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.winningMovieLabel.toUpperCase(), // GANADOR
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 193,
                        width: 150,
                        child: Stack(
                          children: [
                            Hero(
                              tag: 'oscarwinner_movie_${movie.id}',
                              child: LoadImage(
                                url:
                                    '${Environment.tmdbImageBaseUrlW500}${movie.posterPath}',
                                h: 193,
                                w: 150,
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: FavLikeButtonConsumer(
                                data: movie,
                                type: 'Movie',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),
                      // Info de la película
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie
                                  .title, // Asume que tu entidad Movie tiene el título localizado según la petición
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            if (movie.releaseDate != null)
                              Text(
                                '(${movie.releaseDate.year})',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            const SizedBox(height: 8),
                            StarsRatingBarWithInfo(
                              rating: movie.voteAverage,
                              voteCount: movie.voteCount,
                              iconSize: 11, // Ajusta el tamaño
                              color: Colors.yellow.shade600, // Ajusta el color
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.synopsis, // SINOPSIS
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.overview.isNotEmpty
                        ? movie.overview
                        : l10n.noSynopsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 4, // Limitar la sinopsis en la card
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => SizedBox(
        height: 350,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1))),
      error: (error, stack) {
        // ignore: avoid_print
        print('Error loading winner movie (${winnerNominee.tmdbId}): $error');
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('${l10n.errorLoadingData}: ${winnerNominee.title}'),
          ),
        );
      },
    );
  }
}
