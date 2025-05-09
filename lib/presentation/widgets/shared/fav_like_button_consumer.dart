import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/domain/value_objects/favorite_key.dart';

class FavLikeButtonConsumer extends ConsumerStatefulWidget {
  final dynamic data;
  final String type;
  final bool forceFavorite;
  final double iconSize;
  const FavLikeButtonConsumer({
    super.key,
    required this.data,
    required this.type,
    this.forceFavorite = false,
    this.iconSize = 30,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FavLikeButtonConsumerState();
}

class _FavLikeButtonConsumerState extends ConsumerState<FavLikeButtonConsumer> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, ref, _) {
        final favKey = FavoriteKey(widget.data.id, widget.type);
        final favAsync =
            widget.forceFavorite
                ? AsyncValue.data(true)
                : ref.watch(isFavoriteProvider(favKey));

        return favAsync.when(
          loading: () => const CircularProgressIndicator(strokeWidth: 2),
          error: (_, __) => const Icon(Icons.error),
          data:
              (isFav) => Center(
                child: SizedBox(
                  width: widget.iconSize + 3,
                  height: widget.iconSize,
                  child: LikeButton(
                    size: widget.iconSize,
                    likeBuilder:
                        (liked) => Center(
                          child: Icon(
                            Icons.favorite,
                            color: liked ? Colors.red : Colors.white38,
                            size: widget.iconSize,
                          ),
                        ),
                    bubblesColor: const BubblesColor(
                      dotPrimaryColor: Colors.yellowAccent,
                      dotSecondaryColor: Colors.redAccent,
                    ),
                    isLiked: isFav,
                    onTap: (prev) async {
                      await ref
                          .read(favoritesProvider.notifier)
                          .toggleFavorite(widget.data);
                      ref.invalidate(isFavoriteProvider(favKey));
                      return !isFav;
                    },
                  ),
                ),
              ),
        );
      },
    );
  }
}
