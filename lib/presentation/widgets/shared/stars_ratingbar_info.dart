import 'package:flutter/material.dart';
import 'package:cinemania/config/helpers/human_formats.dart';
import 'package:cinemania/presentation/widgets/shared/precise_ratingbar.dart';

class StarsRatingBarWithInfo extends StatelessWidget {
  final double rating;
  final int voteCount;
  final double? iconSize;
  final Color? color;
  final Color? colorVotesText;

  const StarsRatingBarWithInfo({
    super.key,
    required this.rating,
    this.voteCount = 0,
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
          rating: rating * 5 / 10,
          iconSize: iconSize!,
          filledColor: color!,
        ),
        SizedBox(width: 3),
        Text('${rating.toStringAsFixed(1)}/10', style: TextStyle(color: color)),
        SizedBox(width: 5),
        if (voteCount != 0)
          Text(
            '(${HumanFormats.number(voteCount.toDouble())})',
            style: textSyle.bodyMedium,
          ),
      ],
    );
  }
}
