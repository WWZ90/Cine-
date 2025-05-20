import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LoadImage extends StatelessWidget {
  final String url;
  final double w;
  final double h;

  const LoadImage({
    super.key,
    required this.url,
    required this.h,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    final double borderRadius = 5;
    if (url == 'no-poster') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/images/no-poster.png',
          width: w,
          height: h,
          fit: BoxFit.cover,
        ),
      );
    }
    if (url == 'no-avatar') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/images/no-avatar.png',
          width: w,
          height: h,
          fit: BoxFit.cover,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url,
        width: w,
        height: h,
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
          url: url,
          file: LocalImageFileManager.fileFromUrl(url),
          debug: false,
        ),
        width: w, // ancho fijo igual que tu item
        height: h,
        fit: BoxFit.cover,
        frameBuilder: (
          BuildContext context,
          Widget child,
          int? frame, // número de frame cargado
          bool wasSynchronouslyLoaded,
        ) {
          if (wasSynchronouslyLoaded) return child;
          if (frame == null) {
            return Container(
              width: w,
              height: h,
              color: Colors.grey[850],
              alignment: Alignment.center,
              child: CircularProgressIndicator(strokeWidth: 1, color: Colors.white38,),
            );
          }
          return child;
        },
        errorBuilder:
            (context, error, stack) => Container(
              width: w,
              height: h,
              alignment: Alignment.center,
              child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
            ),
      ),
      */
    );
  }
}
