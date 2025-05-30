import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                        AppLocalizations.of(context)!.premiere,
                        formatDateNew(context, movieDetails.releaseDate),
                        context,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: Colors.white12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: _infoBlock(
                        AppLocalizations.of(context)!.budget,
                        HumanFormats.number(movieDetails.budget.toDouble()),
                        context,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: Colors.white12,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: _infoBlock(
                        AppLocalizations.of(context)!.revenue,
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
                    AppLocalizations.of(context)!.synopsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movieDetails.overview.isNotEmpty
                        ? movieDetails.overview
                        : AppLocalizations.of(context)!.noSynopsis,
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
        SizedBox(height: 10),
        VideoTrailer(id: movieDetails.id.toString(), type: 'Movie'),
        SizedBox(height: 10),
        Reviews(id: movieDetails.id.toString(), type: 'Movie'),
        SizedBox(height: 10),
        CastCarousel(id: movieDetails.id.toString(), type: 'Movie'),
        CrewSection(id: movieDetails.id.toString(), type: 'Movie'),
        Similar(id: movieDetails.id.toString(), type: 'Movie'),
      ],
    );
  }
}

Widget _infoBlock(String title, String value, BuildContext context) {
  final textStyle = Theme.of(context).textTheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: textStyle.bodyMedium?.copyWith(color: Colors.grey[500]),
      ),
      const SizedBox(height: 4),
      Text(value, style: textStyle.bodyMedium?.copyWith(color: Colors.white)),
    ],
  );
}
