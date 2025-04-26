import 'package:flutter/material.dart';
import 'package:cinemania/config/helpers/file_storage.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

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
            child: Image(
              image: NetworkToFileImage(
                url: data.posterPath,
                file: LocalImageFileManager.fileFromUrl(data.posterPath),
              ),
              height: 350.0,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            // child: CachedNetworkImage(
            //   fit: BoxFit.cover,
            //   imageUrl: pelicula.getBackgroundImg(),
            //   height: 350.0,
            // ),
          ),
        ),
      ],
    );
  }
}
