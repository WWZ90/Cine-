import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class FavoriteCircle extends StatelessWidget {
  final Size size;
  final double percent;
  final dynamic data;
  const FavoriteCircle({
    super.key,
    required this.size,
    required this.percent,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    //dynamic dataDBProvider;

    return Positioned(
      bottom: size.height * 0.105,
      right: 20,
      child:
          percent < 0.2
              ? TweenAnimationBuilder<double>(
                tween:
                    percent < 0.17
                        ? Tween(begin: 1, end: 0)
                        : Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, widget) {
                  return Transform.scale(
                    scale: 1.0 - value,
                    child: LikeButton(
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 40.0,
                        );
                      },
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Colors.yellowAccent,
                        dotSecondaryColor: Colors.redAccent,
                      ),
                      //isLiked: data.favorit ? true : false,
                      isLiked: false,
                      // onTap: (bool isLiked) {
                      //   //return dataDBProvider.favorit(data, data.favorit);
                      // },
                    ),
                  );
                },
              )
              : Container(),
    );
  }
}
