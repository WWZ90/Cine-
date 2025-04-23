import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/domain/entities/search.dart';
import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/presentation/delegates/multi_search_delegate.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/screens/tv_shows/tv_show_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    //final titleStyle = Theme.of(context).textTheme.titleLarge;
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.black54,
      toolbarHeight: 50,
      centerTitle: true,
      title: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.movie_outlined),
                //SizedBox(width: 5),
                Text('CINE+', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                //Spacer(),
                IconButton(
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
                            ref.read(searchedProvider.notifier).searchByQuery,
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
