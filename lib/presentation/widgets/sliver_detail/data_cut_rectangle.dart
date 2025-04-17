import 'dart:math';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class DataCutRentangle extends StatelessWidget {
  const DataCutRentangle({
    super.key,
    required this.size,
    required this.percent,
    required this.movie,
  });
  final Size size;
  final double percent;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.34, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left:
                  percent > 0.13
                      ? size.width * pow(percent, 5.5).clamp(0.0, 0.2)
                      : 0,
              top:
                  size.height *
                  (percent > 0.48 ? pow(percent, 10.5).clamp(0.0, 0.06) : 0.0),
            ),
            child: Text(
              movie.title,
              style: TextStyle(
                //color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (percent < 0.50) ...[
            const SizedBox(height: 2),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: 1 - pow(percent, 0.05).toDouble(),
              child: CustomBottomDescription(
                movie: movie,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
