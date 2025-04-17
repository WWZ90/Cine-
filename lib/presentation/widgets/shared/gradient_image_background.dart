import 'package:flutter/material.dart';

class GradientImageBackground extends StatelessWidget {
  final List<Color>? colors;
  final List<double> stops;

  const GradientImageBackground({
    super.key,
    this.colors,
    this.stops = const [0.5, 1.0],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Color> gradientColors = colors ??
        [
          Colors.transparent,
          theme.colorScheme.surface, // o theme.scaffoldBackgroundColor
        ];

    assert(gradientColors.length == stops.length, 'Colors and stops must have the same length.');

    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
              stops: stops,
            ),
          ),
        ),
      ),
    );
  }
}
