import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      title: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50, // igual al ancho máximo del botón derecho
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset('assets/images/app_icon.png', width: 23),
                  ),
                ),
                Image.asset('assets/images/cine.png', width: 50),
                SizedBox(
                  width: 50, // igual que el izquierdo
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        final searchedMulti = ref.read(searchedProvider);
                        final searchQuery = ref.read(searchQueryProvider);
                        final response = await showSearch<MultiSearch?>(
                          query: searchQuery,
                          context: context,
                          delegate: MultiSearchDelegate(
                            initialSearchs: searchedMulti,
                            search:
                                ref
                                    .read(searchedProvider.notifier)
                                    .searchByQuery,
                          ),
                        );
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
                          context.pushNamed(
                            PersonScreen.name,
                            extra: {
                              'id': response.id,
                              'name': response.name,
                              'profilePath': response.profilePath,
                              'popularity': response.popularity,
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
