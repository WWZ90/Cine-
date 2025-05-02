import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class Actors extends ConsumerWidget {
  final String id;
  final String type;
  const Actors({required this.id, required this.type, super.key});

  @override
  Widget build(BuildContext context, ref) {
    dynamic actorsAll;
    type == 'Movie'
        ? actorsAll = ref.watch(actorsByMovieProvider)
        : actorsAll = ref.watch(actorsByTVShowProvider);
    if (actorsAll[id] == null) {
      return SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    final actors = actorsAll[id]!;
    return SizedBox(
      height: 248,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: EdgeInsets.all(8.0),
            width: 165,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: LoadImage(url: actor.profilePath, w: 170, h: 183),
                ),
                SizedBox(height: 10),
                Text(actor.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  actor.character ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
