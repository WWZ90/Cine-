import 'package:cinemania/config/helpers/file_storage.dart';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

class CoverPhoto extends StatelessWidget {
  final Size size;
  final Movie movie;
  const CoverPhoto({super.key, required this.size, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      width: size.width * 0.27,
      height: size.height * 0.18,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          image: NetworkToFileImage(
            url: movie.backdropPath,
            file: LocalImageFileManager.fileFromUrl(movie.backdropPath),
          ),
          height: 350.0,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
