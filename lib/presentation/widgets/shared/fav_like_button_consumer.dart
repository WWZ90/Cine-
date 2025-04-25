import 'package:cinemania/domain/value_objects/favorite_key.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

class FavLikeButtonConsumer extends ConsumerStatefulWidget {
  final dynamic data;
  final String type;
  const FavLikeButtonConsumer({
    super.key,
    required this.data,
    required this.type,
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
        final favAsync = ref.watch(
          isFavoriteProvider(favKey),
        );

        return favAsync.when(
          loading: () => const CircularProgressIndicator(strokeWidth: 2),
          error: (_, __) => const Icon(Icons.error),
          data:
              (isFav) => LikeButton(
                likeBuilder:
                    (liked) => Icon(
                      Icons.favorite,
                      color: liked ? Colors.red : Colors.white,
                      size: 30,
                    ),
                bubblesColor: const BubblesColor(
                  dotPrimaryColor: Colors.yellowAccent,
                  dotSecondaryColor: Colors.redAccent,
                ),
                isLiked: isFav,
                onTap: (prev) async {
                  // 1) toggle
                  await ref
                      .read(localStorageDatasourceProvider)
                      .toggleFavorite(widget.data, widget.type);

                  // 2) fuerza recálculo del provider de favoritos
                  ref.invalidate(isFavoriteProvider(favKey));

                  // 3) devuelve el nuevo estado para la animación
                  return !isFav;
                },
              ),
        );
      },
    );
  }
}
