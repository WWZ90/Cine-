import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/config/helpers/date_format.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class TvShowDetailCard extends StatelessWidget {
  final TvShowDetails tvShowDetails;

  const TvShowDetailCard({super.key, required this.tvShowDetails});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _infoBlock(
                        AppLocalizations.of(context)!.firstAirDate,
                        formatDate(tvShowDetails.firstAirDate),
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
                        tvShowDetails.lastEpisodeToAir != null
                            ? '${AppLocalizations.of(context)!.lastEpisode} s${tvShowDetails.lastEpisodeToAir!.seasonNumber}e${tvShowDetails.lastEpisodeToAir!.episodeNumber}'
                            : AppLocalizations.of(context)!.lastEpisode,
                        tvShowDetails.lastEpisodeToAir != null
                            ? '${tvShowDetails.lastEpisodeToAir!.name}\n${formatDate(tvShowDetails.lastEpisodeToAir!.airDate)}'
                            : 'N/A',
                        context,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white12, thickness: 1, height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _infoBlock(
                        AppLocalizations.of(context)!.seasons,
                        '${tvShowDetails.numberOfSeasons}',
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
                        tvShowDetails.nextEpisodeToAir != null
                            ? '${AppLocalizations.of(context)!.nextEpisode} s${tvShowDetails.nextEpisodeToAir!.seasonNumber}e${tvShowDetails.nextEpisodeToAir!.episodeNumber}'
                            : AppLocalizations.of(context)!.nextEpisode,
                        tvShowDetails.nextEpisodeToAir != null
                            ? '${tvShowDetails.nextEpisodeToAir!.name}\n${formatDate(tvShowDetails.nextEpisodeToAir!.airDate)}'
                            : 'N/A',
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
                  tvShowDetails.genres.map((genre) {
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
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tvShowDetails.overview.isNotEmpty
                        ? tvShowDetails.overview
                        : AppLocalizations.of(context)!.synopsis,
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
        VideoTrailer(id: tvShowDetails.id.toString(), type: 'TVShow'),
        SizedBox(height: 10),
        Reviews(id: tvShowDetails.id.toString(), type: 'TVShow'),
        SizedBox(height: 10),
        Actors(id: tvShowDetails.id.toString(), type: 'TVShow'),
        Similar(id: tvShowDetails.id.toString(), type: 'TVShow'),
      ],
    );
  }
}

Widget _infoBlock(String title, String value, BuildContext context) {
  final textStyle = Theme.of(context).textTheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 16, color: Colors.grey[500])),
      const SizedBox(height: 4),
      Text(value, style: textStyle.bodyMedium?.copyWith(color: Colors.white)),
    ],
  );
}
