import 'package:flutter/material.dart';
import 'package:cinemania/config/helpers/human_formats.dart';
import 'package:cinemania/presentation/widgets/shared/precise_ratingbar.dart';

class StarsRatingBarWithInfo extends StatelessWidget {
  final double rating;
  final int voteCount;
  final String? type;
  final double? iconSize;
  final Color? color;
  final Color? colorVotesText;

  const StarsRatingBarWithInfo({
    super.key,
    required this.rating,
    this.voteCount = 0,
    this.type = 'MovieTVShow',
    this.iconSize = 20,
    this.color = Colors.yellow,
    this.colorVotesText = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PreciseRatingBar(
          rating: (type != "Person") ? rating * 5 / 10 : rating * 5 / 100,
          iconSize: iconSize!,
          filledColor: color!,
        ),
        SizedBox(width: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Baseline(
              baseline:
                  20, // La altura en la que quieres que se alinee el texto
              baselineType: TextBaseline.alphabetic,
              child: Text(
                rating.toStringAsFixed(1), // Rating
                style: TextStyle(
                  fontSize: 20, // Tamaño de fuente más grande para el rating
                  color: color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Baseline(
              baseline: 18, // El mismo valor para que se alinee con el número
              baselineType: TextBaseline.alphabetic,
              child: Text(
                 (type != "Person") ? '/10' : '/100', // "/10" más pequeño
                style: TextStyle(
                  fontSize: 13, // Tamaño de fuente más pequeño para "/10"
                  color: color,
                ),
              ),
            ),
            SizedBox(width: 5),
            if (voteCount != 0 && type != 'Person')
              Baseline(
                baseline: 15, // El mismo valor para que se alinee con el número
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  '(${HumanFormats.number(voteCount.toDouble())})',
                  style: TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
