import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BackgroundSilver extends StatelessWidget {
  final dynamic data;
  const BackgroundSilver({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.rectangle),
            child:
            /*
            Image(
              image: NetworkToFileImage(
                url: data.posterPath,
                file: LocalImageFileManager.fileFromUrl(data.posterPath),
              ),
              height: 350.0,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            */
            CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: data.posterPath,
              height: 350.0,
              width: MediaQuery.of(context).size.width,
              placeholder:
                  (context, url) => Center(child: SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(strokeWidth: 1))),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ],
    );
  }
}
