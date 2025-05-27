import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/config/helpers/date_format.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:cinemania/infrastructure/models/moviedb/oscars/oscars_model.dart';

class CeremonyListItem extends StatefulWidget {
  final Ceremony ceremony;
  final bool shouldLoadNonWinners;

  const CeremonyListItem({
    super.key,
    required this.ceremony,
    this.shouldLoadNonWinners = false,
  });

  @override
  State<CeremonyListItem> createState() => _CeremonyListItemState();
}

class _CeremonyListItemState extends State<CeremonyListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final ceremony = widget.ceremony;

    String getLocalizedCeremonyTitle(
      BuildContext context,
      int number,
      int year,
    ) {
      final l10n = AppLocalizations.of(context)!;
      return l10n.ceremonyTitle(number.toString(), year.toString());
    }

    String getOtherNomineesLabel(String category) {
      if (category == 'Best Picture' ||
          category == 'Animated Feature Film' ||
          category == 'Visual Effects') {
        return l10n.otherNomineesFemaleLabel; // "Otras nominadas"
      }

      if (category == 'Best Actress') {
        return l10n.otherNomineesFemaleLabel; // "Otras nominadas"
      }

      return l10n.otherNomineesMaleLabel; // "Otros nominados"
    }

    return Padding(
      key: ValueKey('ceremony_padding_${ceremony.ceremonyYear}'),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        key: ValueKey('ceremony_column_${ceremony.ceremonyYear}'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getLocalizedCeremonyTitle(
              context,
              ceremony.ceremonyNumber,
              ceremony.ceremonyYear,
            ),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          if (ceremony.ceremonyDate != null)
            Text(
              formatDateNew(context, DateTime.parse(ceremony.ceremonyDate!)),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),

          const SizedBox(height: 10),

          ...ceremony.categories.map((category) {
            String type = "Movie";

            if (category.category == "Best Director") {
              type = "Person";
            }

            final List<Nominee> winners = category.allWinners;
            final List<Nominee> nonWinners = category.nonWinners;

            return Column(
              key: ValueKey(
                'category_${ceremony.ceremonyYear}_${category.category}',
              ),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (winners.isNotEmpty)
                  ...winners.map((winner) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child:
                          type == 'Movie'
                              ? OscarMovieWinnerCard(
                                key: ValueKey(
                                  'winner_${winner.tmdbId}_${category.category}',
                                ),
                                winnerNominee: winner,
                              )
                              : OscarPersonWinnerCard(
                                key: ValueKey(
                                  'winner_${winner.tmdbId}_${category.category}',
                                ),
                                winnerNominee: winner,
                              ),
                    );
                  }),

                if (nonWinners.isNotEmpty)
                  !widget.shouldLoadNonWinners
                      ? const SizedBox(height: 300)
                      : Consumer(
                        key: ValueKey(
                          'nonwinners_consumer_${ceremony.ceremonyYear}_${category.category}',
                        ),
                        builder: (context, ref, child) {
                          final nomineeKey = generateNomineeIdsKey(nonWinners);
                          final provider =
                              type == "Movie"
                                  ? nonWinnerMoviesProvider
                                  : nonWinnerPersonsProvider;

                          final dataAsync = ref.watch(
                            provider((key: nomineeKey, nominees: nonWinners)),
                          );

                          return dataAsync.when(
                            data: (data) {
                              if (data.isEmpty) return const SizedBox.shrink();

                              final orderedNonWinners =
                                  category.nonWinners
                                      .where((nominee) => nominee.name != null)
                                      .toList()
                                    ..sort((a, b) {
                                      final indexA = data.indexWhere(
                                        (person) =>
                                            (person as dynamic).name ==
                                            a.name,
                                      );
                                      final indexB = data.indexWhere(
                                        (person) =>
                                            (person as dynamic).name ==
                                            b.name,
                                      );
                                      return indexA.compareTo(indexB);
                                    });

                              return SizedBox(
                                height: type == "Person" ? 280 : 275,
                                child: SliderHorizontalListview(
                                  key: PageStorageKey<String>(
                                    'slider_${ceremony.ceremonyYear}_${category.category}_$nomineeKey',
                                  ),
                                  allData: data,
                                  title: getOtherNomineesLabel(
                                    category.category,
                                  ),
                                  type: type,
                                  isForOscars: type == "Person" ? true : false,
                                  forMovies: type == "Person" ? orderedNonWinners : null,
                                ),
                              );
                            },
                            loading:
                                () => const SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  ),
                                ),
                            error: (_, __) => const SizedBox.shrink(),
                          );
                        },
                      ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
