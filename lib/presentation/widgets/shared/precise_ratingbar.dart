import 'package:flutter/material.dart';

class PreciseRatingBar extends StatelessWidget {
  final double rating; // Ej: 3.7
  final double iconSize;
  final Color filledColor;
  final Color unfilledColor;

  const PreciseRatingBar({
    super.key,

    required this.rating,
    this.iconSize = 24.0,
    this.filledColor = Colors.amber,
    this.unfilledColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final starRating = rating - index;

        return Stack(
          children: [
            Icon(Icons.star, size: iconSize, color: unfilledColor),
            if (starRating > 0)
              ClipRect(
                clipper: _StarClipper(percent: starRating.clamp(0.0, 1.0)),
                child: Icon(Icons.star, size: iconSize, color: filledColor),
              ),
          ],
        );
      }),
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double percent; // Entre 0.0 y 1.0

  _StarClipper({required this.percent});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, size.width * percent, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) {
    return oldClipper.percent != percent;
  }
}
