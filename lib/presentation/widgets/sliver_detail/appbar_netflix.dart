import 'package:flutter/material.dart';
import 'dart:math';

import 'package:cinemania/domain/entities/video.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class AppBarNetflix extends SliverPersistentHeaderDelegate {
  final double maxExtend;
  final double minExtend;
  final Size size;
  final dynamic data;
  final List<Video>? videos;

  const AppBarNetflix({
    required this.maxExtend,
    required this.minExtend,
    required this.size,
    required this.data,
    required this.videos,
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
        videos!.isNotEmpty
            ? VideoPlay(
              size: size,
              percent: percent,
              id: data.id,
              urlImage: data.posterPath,
              image: data.posterPath,
              video: videos!,
            )
            : SizedBox(),
        FavoriteCircle(size: size, percent: percent, data: data),
        Positioned(
          top: 30,
          left: 10,
          child: IconButton.filled(
            color: Colors.black45,
            focusColor: Colors.black38,
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios_outlined),
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
