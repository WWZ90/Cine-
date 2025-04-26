import 'package:flutter/material.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class CustomBottomDescription extends StatelessWidget {
  final dynamic data;
  const CustomBottomDescription({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.originalTitle,
          style: TextStyle(
            //color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
        (data.voteAverage > 0)
            ? Row(
              children: <Widget>[
                StarsRatingBarWithInfo(
                  rating: data.voteAverage,
                  voteCount: data.voteCount,
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
