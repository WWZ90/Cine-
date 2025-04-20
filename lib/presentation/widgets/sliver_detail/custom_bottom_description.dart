import 'package:cinemania/domain/entities/movie.dart';

import 'package:flutter/material.dart';

import '../widgets.dart';

class CustomBottomDescription extends StatelessWidget {
  final Movie movie;
  const CustomBottomDescription({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.originalTitle,
          style: TextStyle(
            //color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
        (movie.voteAverage > 0)
            ? Row(
              children: <Widget>[
                StarsRatingBarWithInfo(
                  rating: movie.voteAverage,
                  voteCount: movie.voteCount,
                  iconSize: 13,
                  color: Colors.yellow,
                ),
              ],
            )
            : Container(),
      ],
    );
  }
}
