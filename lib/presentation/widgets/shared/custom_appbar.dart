import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/delegates/multi_search_delegate.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color.fromARGB(135, 17, 17, 17),
      toolbarHeight: 50,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              padding: EdgeInsets.zero,
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/app_icon.png', width: 23),
                    const SizedBox(width: 5),
                    Image.asset('assets/images/cine.png', width: 50),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              padding: EdgeInsets.zero,
              onPressed: () async {
                ref.read(isFullscreenProvider.notifier).state = true;
                final searchedMulti = ref.read(searchedProvider);
                final searchQuery = ref.read(searchQueryProvider);
                final response = await showSearch<MultiSearch?>(
                  query: searchQuery,
                  context: context,
                  delegate: MultiSearchDelegate(
                    searchPlaceholder:
                        AppLocalizations.of(context)!.searchPlaceholder,
                    movieLabel: AppLocalizations.of(context)!.movie,
                    tvLabel: AppLocalizations.of(context)!.tvShow,
                    personLabel: AppLocalizations.of(context)!.person,
                    knownForLabel: AppLocalizations.of(context)!.knownFor,
                    initialSearchs: searchedMulti,
                    search: ref.read(searchedProvider.notifier).searchByQuery,
                  ),
                );
                ref.read(isFullscreenProvider.notifier).state = false;
                if (!context.mounted || response == null) return;

                if (response.mediaType == 'movie') {
                  Movie movie = Movie(
                    adult: response.adult,
                    backdropPath: response.backdropPath!,
                    genreIds: response.genreIds!,
                    id: response.id,
                    originalLanguage: response.originalLanguage!,
                    originalTitle: response.originalTitle!,
                    overview: response.overview!,
                    popularity: response.popularity,
                    posterPath: response.posterPath!,
                    releaseDate: response.releaseDate!,
                    title: response.title!,
                    video: response.video!,
                    voteAverage: response.voteAverage!,
                    voteCount: response.voteCount!,
                  );

                  context.pushNamed(MovieScreen.name, extra: movie);
                }

                if (response.mediaType == 'tv') {
                  TVShow tvShow = TVShow(
                    id: response.id,
                    title: response.name!,
                    originalTitle: response.originalName!,
                    adult: response.adult,
                    backdropPath: response.backdropPath!,
                    genreIds: response.genreIds!,
                    originCountry: response.originCountry!,
                    originalLanguage: response.originalLanguage!,
                    overview: response.overview!,
                    popularity: response.popularity,
                    posterPath: response.posterPath!,
                    firstAirDate: response.firstAirDate!,
                    voteAverage: response.voteAverage!,
                    voteCount: response.voteCount!,
                  );

                  context.pushNamed(TVShowScreen.name, extra: tvShow);
                }

                if (response.mediaType == 'person') {
                  Person person = Person(
                    id: response.id,
                    name: response.name!,
                    originalName: response.originalName!,
                    mediaType: MediaType.PERSON,
                    adult: response.adult,
                    popularity: response.popularity,
                    gender: response.gender!,
                    knownForDepartment: parseKnownForDepartment(
                      response.knownForDepartment,
                    ),
                    profilePath: response.profilePath,
                    uniqueID: "${response.id}-person-from-search"
                  );
                  context.pushNamed(PersonScreen.name, extra: person);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
