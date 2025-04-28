import 'dart:math';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemania/presentation/widgets/widgets.dart';

class AppBarNetflix extends SliverPersistentHeaderDelegate {
  final double maxExtend;
  final double minExtend;
  final Size size;
  final dynamic data;
  final String type;

  const AppBarNetflix({
    required this.maxExtend,
    required this.minExtend,
    required this.size,
    required this.data,
    required this.type,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final percent = shrinkOffset / maxExtend;
    //validate the angle at which the card returns
    final uploadLimit = 13 / 100;
    //return value of the card
    final valueBack = (1 - percent - 0.77).clamp(0, uploadLimit);

    final fixRotation = pow(percent, 1.5);

    final card = CoverCard(
      size: size,
      percent: percent,
      uploadLimit: uploadLimit,
      valueBack: valueBack,
      data: data,
    );

    final bottomsSliverBar = CustomBottomSliverBar(
      size: size,
      fixRotation: fixRotation,
      percent: percent,
      data: data,
    );

    return Stack(
      children: [
        BackgroundSilver(data: data),
        bottomsSliverBar,
        if (percent > uploadLimit) ...[
          card,
          bottomsSliverBar,
        ] else ...[
          bottomsSliverBar,
          card,
        ],

        VideoPlayIcon(
          size: size,
          percent: percent,
          type: data is Movie ? 'Movie' : 'TVShow',
          data: data,
        ),
        FavoriteCircle(size: size, percent: percent, data: data, type: type),
        Positioned(
          top: 30,
          left: 10,
          child: Material(
            color: const Color.fromARGB(255, 99, 99, 99).withOpacity(0.6),
            shape: CircleBorder(), // Si quieres que el fondo sea circular
            child: IconButton(
              color: const Color.fromARGB(255, 255, 255, 255), // Color del icono
              focusColor: Colors.black38,
              onPressed: () {
                context.pop();
              },
              icon: Icon(Icons.arrow_back_ios_outlined),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => maxExtend;

  @override
  double get minExtent => minExtend;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
