import 'package:cinemania/domain/entities/movie.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class CustomBottomSliver extends StatelessWidget {
  final Size size;
  final double percent;
  final Movie movie;

  const CustomBottomSliver({super.key, 
    required this.size,
    required this.percent,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    //final appTheme = Provider.of<ThemeChanger>(context);
    final backgroundColor = Theme.of(context).colorScheme.surface;
    return SizedBox(
      height: size.height * 0.11,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: CutRectangle(backgroundColor),
          ),
          DataCutRentangle(
            size: size,
            percent: percent,
            movie: movie,
          ),
        ],
      ),
    );
  }
}
