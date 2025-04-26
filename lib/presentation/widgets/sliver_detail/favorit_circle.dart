import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/presentation/widgets/widgets.dart';

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
            child: FavLikeButtonConsumer(data: widget.data, type: widget.type, iconSize: 40,),
          );
        },
      ),
    );
  }
}
