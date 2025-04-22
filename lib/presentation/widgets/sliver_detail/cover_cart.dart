import 'package:cinemania/domain/entities/movie.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class CoverCard extends StatelessWidget {
  final Size size;
  final double percent;
  final double uploadLimit;
  final num valueBack;
  final dynamic data;
  final double angleForCard = 7;

  const CoverCard({
    super.key,
    required this.size,
    required this.percent,
    required this.uploadLimit,
    required this.valueBack,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.35,
      left: size.width / 24,
      child: Transform(
        alignment: Alignment.topRight,
        transform:
            Matrix4.identity()..rotateZ(
              percent > uploadLimit
                  ? (valueBack * angleForCard)
                  : percent * angleForCard,
            ),
        child: CoverPhoto(size: size, data: data),
      ),
    );
  }
}
