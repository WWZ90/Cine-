import 'package:cinemania/domain/value_objects/favorite_key.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

class FavoriteCircle extends ConsumerStatefulWidget {
  final Size size;
  final double percent;
  final dynamic data;
  final String type;
  const FavoriteCircle({
    super.key,
    required this.size,
    required this.percent,
    required this.data,
    required this.type,
  });

  @override
  ConsumerState<FavoriteCircle> createState() => _FavoriteCircleState();
}

class _FavoriteCircleState extends ConsumerState<FavoriteCircle> {
  late Future<bool> _isFavFuture;

  void _loadFavorite() {
    _isFavFuture = ref
        .read(localStorageDatasourceProvider)
        .isFavorite(widget.data.id, widget.type);
  }

  @override
  void initState() {
    super.initState();
    // Se genera una sola vez al montar el widget
    _loadFavorite();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.percent >= 0.2) return const SizedBox();

    return Positioned(
      bottom: widget.size.height * 0.105,
      right: 20,
      child: TweenAnimationBuilder<double>(
        tween:
            widget.percent < 0.17
                ? Tween(begin: 1, end: 0)
                : Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 300),
        builder: (_, value, __) {
          return Transform.scale(
            scale: 1 - value,
            child: FutureBuilder<bool>(
              future: _isFavFuture,
              builder: (context, snapshot) {
                final isFav = snapshot.data ?? false;
                return LikeButton(
                  likeBuilder:
                      (liked) => Icon(
                        Icons.favorite,
                        color: liked ? Colors.red : Colors.white,
                        size: 40,
                      ),
                  bubblesColor: const BubblesColor(
                    dotPrimaryColor: Colors.yellowAccent,
                    dotSecondaryColor: Colors.redAccent,
                  ),
                  isLiked: isFav,
                  onTap: (prev) async {
                    final favKey = FavoriteKey(widget.data.id, widget.type);

                    await ref
                        .read(localStorageDatasourceProvider)
                        .toggleFavorite(widget.data, widget.type);

                    // recarga el Future
                    setState(() => _loadFavorite());

                    ref.invalidate(isFavoriteProvider(favKey));

                    // devuelve el nuevo estado para LikeButton
                    return await _isFavFuture;
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
