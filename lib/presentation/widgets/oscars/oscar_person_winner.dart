import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemania/config/constants/environment.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/infrastructure/models/moviedb/oscars/oscars_model.dart';

class OscarPersonWinnerCard extends ConsumerWidget {
  final Nominee winnerNominee;

  const OscarPersonWinnerCard({super.key, required this.winnerNominee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // final movieAsync = ref.watch(
    //   movieProvider((movieId: winnerNominee.tmdbId!)),
    // );

    final personAsync = ref.watch(
      personProvider((personId: winnerNominee.tmdbId!)),
    );

    return personAsync.when(
      data: (person) {
        if (person == null) {
          return Card(
            // Tarjeta de error si la persona no se encuentra
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${l10n.errorLoadingPerson}: ${winnerNominee.name} (ID: ${winnerNominee.tmdbId})',
              ),
            ),
          );
        }

        person.uniqueID = "${person.id}-person-oscarWinner-${winnerNominee.tmdbId}";

        return GestureDetector(
          onTap: () {
            context.pushNamed(PersonScreen.name, extra: person);
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
                    l10n.winningDirectorLabel.toUpperCase(), // GANADOR
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
                              tag:
                                  'oscarwinner_person_${person.id}_for_${winnerNominee.title}',
                              child: LoadImage(
                                url:
                                    '${Environment.tmdbImageBaseUrlW500}${person.profilePath}',
                                h: 193,
                                w: 150,
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: FavLikeButtonConsumer(
                                data: person,
                                type: 'Person',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              person.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            StarsRatingBarWithInfo(
                              rating: person.popularity,
                              voteCount: 0,
                              iconSize: 11, // Ajusta el tamaño
                              color: Colors.yellow.shade600, // Ajusta el color
                              type: AppLocalizations.of(context)!.person,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '${l10n.forLabel}:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              winnerNominee.title!,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading:
          () => SizedBox(
            height: 350,
            child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
          ),
      error: (error, stack) {
        // ignore: avoid_print
        print('Error loading winner person (${winnerNominee.tmdbId}): $error');
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('${l10n.errorLoadingData}: ${winnerNominee.name}'),
          ),
        );
      },
    );
  }
}
