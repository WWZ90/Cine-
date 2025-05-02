import 'package:flutter/material.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:cinemania/config/helpers/human_formats.dart';
import 'package:cinemania/config/helpers/date_format.dart';

class MovieDetailCard extends StatelessWidget {
  final MovieDetail movieDetails;

  const MovieDetailCard({super.key, required this.movieDetails});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Color(0xFF1C1F26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.blueGrey, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _infoBlock(
                        'Estreno',
                        formatDate(movieDetails.releaseDate),
                        context,
                      ),
                    ),
                    Container(
                      width: 1, // grosor de la línea
                      height: 60, // altura (ajusta según necesidad)
                      color: Colors.white12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: _infoBlock(
                        'Presupuesto',
                        HumanFormats.number(movieDetails.budget.toDouble()),
                        context,
                      ),
                    ),
                    Container(
                      width: 1, // grosor de la línea
                      height: 60, // altura (ajusta según necesidad)
                      color: Colors.white12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: _infoBlock(
                        'Recaudado',
                        HumanFormats.number(movieDetails.revenue.toDouble()),
                        context,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Center(
            child: Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children:
                  movieDetails.genres.map((genre) {
                    return Chip(
                      backgroundColor: Color(0xFF2C2C2C),
                      label: Text(
                        genre.name,
                        style: textStyle.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(color: Colors.blueGrey),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Card(
            color: Color(0xFF1C1F26),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white12, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sinopsis',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movieDetails.overview.isNotEmpty
                        ? movieDetails.overview
                        : 'No hay sinopsis disponible.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        VideoTrailer(id: movieDetails.id.toString(), type: 'Movie'),
        SizedBox(height: 10),
        Reviews(id: movieDetails.id.toString(), type: 'Movie'),
        SizedBox(height: 15),
        Actors(id: movieDetails.id.toString(), type: 'Movie'),
        Similar(id: movieDetails.id.toString(), type: 'Movie'),
        SizedBox(height: 20),
      ],
    );
  }
}

Widget _infoBlock(String title, String value, BuildContext context) {
  final textStyle = Theme.of(context).textTheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(title, style: TextStyle(fontSize: 16, color: Colors.grey[500])),
      const SizedBox(height: 4),
      Text(value, style: textStyle.bodyMedium?.copyWith(color: Colors.white)),
    ],
  );
}
