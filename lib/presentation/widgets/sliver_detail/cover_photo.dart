import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoverPhoto extends StatelessWidget {
  final Size size;
  final dynamic data;
  const CoverPhoto({super.key, required this.size, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      width: size.width * 0.27,
      height: size.height * 0.18,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: data.posterPath,
          height: 350.0,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Center(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ),
              ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
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
      ),
    );
  }
}
