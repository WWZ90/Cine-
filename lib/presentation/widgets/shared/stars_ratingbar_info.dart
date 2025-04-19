import 'package:cinemania/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/presentation/widgets/shared/precise_ratingbar.dart';

class StarsRatingBarWithInfo extends StatelessWidget {
  final Movie movie;
  final double? iconSize;
  final Color? color;
  final Color? colorVotesText;

  const StarsRatingBarWithInfo({
    super.key,
    required this.movie,
    this.iconSize = 20,
    this.color = Colors.yellow,
    this.colorVotesText = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final textSyle = Theme.of(context).textTheme;
    return Row(
      children: [
        PreciseRatingBar(
          rating: movie.voteAverage * 5 / 10,
          iconSize: iconSize!,
          filledColor: color!,
        ),
        SizedBox(width: 3),
        Text(
          '${movie.voteAverage.toStringAsFixed(1)}/10',
          style: TextStyle(color: color),
        ),
        SizedBox(width: 5),
        Text(
          '(${HumanFormats.number(movie.voteCount.toDouble())})',
          style: textSyle.bodyMedium,
        ),
      ],
    );
  }
}
