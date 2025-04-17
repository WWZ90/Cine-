import 'package:cinemania/domain/entities/movie.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class CustomBottomSliverBar extends StatelessWidget {
  final Size size;
  final num fixRotation;
  final double percent;
  final Movie movie;
  const CustomBottomSliverBar({
    super.key,
    required this.size,
    required this.fixRotation,
    required this.percent,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: -size.width * fixRotation.clamp(0, 0.45),
      right: 0,
      child: CustomBottomSliver(size: size, percent: percent, movie: movie),
    );
  }
}
