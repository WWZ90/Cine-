import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/infrastructure/mappers/castperson_to_person.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class CastCarousel extends ConsumerWidget {
  final String id;
  final String type;
  const CastCarousel({required this.id, required this.type, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsStateProvider =
        type == 'Movie' ? movieCreditsProvider : tvShowCreditsProvider;
    final creditsMap = ref.watch(creditsStateProvider);
    final CreditsData? creditsData = creditsMap[id];

    if (creditsData == null) {
      return SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
      );
    }

    final List<CastPerson> cast = creditsData.cast;

    if (cast.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            top: 15.0,
            bottom: 5.0,
            right: 10.0,
          ),
          child: Text(
            AppLocalizations.of(context)!.cast,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final CastPerson actor = cast[index];
              actor.uniqueID =
                  '${actor.id}-cast-${actor.character.replaceAll(" ", "-")}';

              return GestureDetector(
                onTap: () {
                  context.pushNamed(PersonScreen.name, extra: actor.toPerson());
                },
                child: FadeInRight(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    width: 115,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LoadImage(
                                url: actor.profilePath,
                                w: 90,
                                h: 90,
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: FavLikeButtonConsumer(
                                data: actor.toPerson(),
                                type: 'Person',
                                iconSize: 22,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          actor.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        Text(
                          actor.character,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
