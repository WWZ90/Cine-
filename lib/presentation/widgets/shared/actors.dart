import 'package:cinemania/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

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
    return SizedBox(
      height: 175,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
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
            child: Container(
              padding: EdgeInsets.all(8.0),
              width: 115,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInRight(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: LoadImage(url: actor.profilePath, w: 100, h: 100),
                    ),
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
          );
        },
      ),
    );
  }
}
