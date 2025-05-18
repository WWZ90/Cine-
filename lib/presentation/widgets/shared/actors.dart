import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/domain/entities/cast_person.dart' as domain;
import 'package:cinemania/infrastructure/mappers/castperson_to_person.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class Actors extends ConsumerWidget {
  final String id;
  final String type;
  const Actors({required this.id, required this.type, super.key});

  @override
  Widget build(BuildContext context, ref) {
    dynamic actorsAll;
    type == 'Movie'
        ? actorsAll = ref.watch(castByMovieProvider)
        : actorsAll = ref.watch(castByTVShowProvider);

    if (actorsAll[id] == null) {
      return SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    final actors = actorsAll[id]!;
    if (actors.isNotEmpty) {
      return SizedBox(
        height: 175,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          itemBuilder: (context, index) {
            final domain.CastPerson actor = actors[index];
            return GestureDetector(
              onTap: () {
                context.pushNamed(
                  PersonScreen.name,
                  extra: {
                    'id': actor.id,
                    'name': actor.name,
                    'profilePath': actor.profilePath,
                  },
                );
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
                            borderRadius: BorderRadius.circular(60),
                            child: LoadImage(
                              url: actor.profilePath,
                              w: 100,
                              h: 100,
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 10,
                            child: FavLikeButtonConsumer(
                              data: actor.toPerson(),
                              type: 'Person',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        actor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        actor.character ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
