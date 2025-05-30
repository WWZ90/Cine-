import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/infrastructure/mappers/crewperson_to_person.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

const List<String> mainCrewJobs = [
  'Director',
  'Co-Director',
  'Screenplay', 
  'Writer',
  'Story', 
  'Producer',
  'Executive Producer',
  'Consulting Producer',
  'Visual Effects',
  'Visual Effects Producer',
  'Visual Effects Supervisor',
  'Director of Photography', 
  'Editor', 
  'Production Design', 
  'Costume Design',
  'Makeup Artist',
  'Art Direction', 
  'Original Music Composer',
  'Music', 
  'Casting',
];

String getLocalizedCrewJob(BuildContext context, String tmdbJob) {
  final l10n = AppLocalizations.of(context)!;
  switch (tmdbJob) {
    case 'Director':
      return l10n.job_Director;
    case 'Co-Director':
      return l10n.job_CoDirector; 
    case 'Screenplay':
      return l10n.job_Screenplay;
    case 'Writer':
      return l10n.job_Writer;
    case 'Story':
      return l10n.job_Story;
    case 'Producer':
      return l10n.job_Producer;
    case 'Executive Producer':
      return l10n.job_ExecutiveProducer;
    case 'Consulting Producer':
      return l10n.job_ConsultingProducer;
    case 'Visual Effects':
      return l10n.job_VisualEffects;
    case 'Visual Effects Producer':
      return l10n.job_VisualEffectsProducer;
    case 'Visual Effects Supervisor':
      return l10n.job_VisualEffectsSupervisor;
    case 'Director of Photography':
      return l10n.job_DirectorOfPhotography;
    case 'Editor':
      return l10n.job_Editor;
    case 'Production Design':
      return l10n.job_ProductionDesign;
    case 'Custome Design':
      return l10n.job_CostumeDesign;
    case 'Makeup Artist':
      return l10n.job_MakeupArtist;
    case 'Art Direction':
      return l10n.job_ArtDirection;
    case 'Original Music Composer':
      return l10n.job_OriginalMusicComposer;
    case 'Music':
      return l10n.job_Music;
    case 'Casting':
      return l10n.job_Casting;
    default:
      return tmdbJob;
  }
}

class CrewSection extends ConsumerWidget {
  final String id;
  final String type;
  const CrewSection({required this.id, required this.type, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsStateProvider =
        type == 'Movie' ? movieCreditsProvider : tvShowCreditsProvider;
    final creditsMap = ref.watch(creditsStateProvider);
    final CreditsData? creditsData = creditsMap[id];

    if (creditsData == null) {
      return SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
      );
    }

    List<CrewPerson> allCrewRaw = creditsData.crew;

    if (allCrewRaw.isEmpty) {
      return SizedBox.shrink();
    }

    Set<int> personIdsAlreadyInList = {};
    List<CrewPerson> finalDisplayCrew = [];

    for (String priorityJob in mainCrewJobs) {
      List<CrewPerson> membersWithThisJob =
          allCrewRaw
              .where(
                (member) =>
                    member.job == priorityJob &&
                    !personIdsAlreadyInList.contains(member.id),
              )
              .toList();
      for (var member in membersWithThisJob) {
        finalDisplayCrew.add(member);
        personIdsAlreadyInList.add(member.id);
      }
    }

    if (finalDisplayCrew.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            top: 15.0,
            bottom: 5.0,
            right: 10.0,
          ),
          child: Text(
            AppLocalizations.of(context)!.crew,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: finalDisplayCrew.length,
            itemBuilder: (context, index) {
              final CrewPerson member = finalDisplayCrew[index];
              member.uniqueID =
                  '${member.id}-crew-${member.job.replaceAll(" ", "-")}-$index';

              return GestureDetector(
                onTap:
                    () => context.pushNamed(
                      PersonScreen.name,
                      extra: member.toPerson(),
                    ),
                child: FadeInRight(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    width: 115,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LoadImage(
                                url: member.profilePath!,
                                w: 90,
                                h: 90,
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: FavLikeButtonConsumer(
                                data: member.toPerson(),
                                type: 'Person',
                                iconSize: 22,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 5),
                        Text(
                          member.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          getLocalizedCrewJob(context, member.job),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
