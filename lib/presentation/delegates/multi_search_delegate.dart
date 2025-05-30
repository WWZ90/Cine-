import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemania/config/helpers/known_for_department.dart';
import 'package:cinemania/domain/entities/search.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

typedef SearchCallback = Future<List<MultiSearch>> Function(String query);

class MultiSearchDelegate extends SearchDelegate<MultiSearch?> {
  final SearchCallback search;
  List<MultiSearch> initialSearchs;

  final String searchPlaceholder;
  final String movieLabel;
  final String tvLabel;
  final String personLabel;
  final String knownForLabel;

  StreamController<List<MultiSearch>> debouncedMultiSearch =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  MultiSearchDelegate({
    required this.search,
    required this.initialSearchs,
    required this.searchPlaceholder,
    required this.movieLabel,
    required this.tvLabel,
    required this.personLabel,
    required this.knownForLabel,
  }) : super(
         searchFieldLabel: searchPlaceholder,
         searchFieldStyle: const TextStyle(fontSize: 18),
       );

  void clearStreams() {
    debouncedMultiSearch.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      final searchs = await search(query);
      initialSearchs = searchs;
      debouncedMultiSearch.add(searchs);
      isLoadingStream.add(false);
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialSearchs,
      stream: debouncedMultiSearch.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final searchs = snapshot.data;

          return _SearchsItems(
            searchs: searchs,
            onSelected: (context, result) {
              clearStreams();
              close(context, result);
            },
            movieLabel: movieLabel,
            tvLabel: tvLabel,
            personLabel: personLabel,
            knownForLabel: knownForLabel,
          );
        } else {
          return Container(color: Colors.blueGrey.shade900);
        }
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        titleSpacing: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: Duration(seconds: 1),
              spins: 5,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: Icon(Icons.refresh_rounded),
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            duration: Duration(milliseconds: 20),
            child: IconButton(
              onPressed: () => query = '',
              icon: Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => {clearStreams(), close(context, null)},
      icon: Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }
}

class _SearchsItems extends StatelessWidget {
  final List? searchs;
  final Function onSelected;
  final String movieLabel;
  final String tvLabel;
  final String personLabel;
  final String knownForLabel;

  const _SearchsItems({
    required this.searchs,
    required this.onSelected,
    required this.movieLabel,
    required this.tvLabel,
    required this.personLabel,
    required this.knownForLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: ListView(
        children:
            searchs!.map((response) {
              if (response.mediaType == "movie") {
                return GestureDetector(
                  onTap: () => onSelected(context, response),
                  child: _ListItems(
                    type: movieLabel,
                    imgUrl: response.posterPath ?? '',
                    title: response.title ?? '',
                    rating: response.voteAverage ?? 0,
                    voteCount: response.voteCount ?? 0,
                    overview: response.overview ?? '',
                    knownForLabel: knownForLabel,
                  ),
                );
              } else if (response.mediaType == "person") {
                return GestureDetector(
                  onTap: () => onSelected(context, response),
                  child: _ListItems(
                    type: personLabel,
                    imgUrl: response.profilePath ?? '',
                    title: response.name ?? '',
                    knownForDepartment: response.knownForDepartment ?? '',
                    overview: '',
                    knownForLabel: knownForLabel,
                  ),
                );
              } else if (response.mediaType == "tv") {
                return GestureDetector(
                  onTap: () => onSelected(context, response),
                  child: _ListItems(
                    type: tvLabel,
                    imgUrl: response.posterPath ?? '',
                    title: response.name ?? '',
                    rating: response.voteAverage ?? 0,
                    voteCount: response.voteCount ?? 0,
                    overview: response.overview ?? '',
                    knownForLabel: knownForLabel,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }).toList(),
      ),
    );
  }
}

class _ListItems extends StatelessWidget {
  final String imgUrl;
  final String title;
  final double rating;
  final int voteCount;
  final String overview;
  final String type;
  final String knownForDepartment;
  final String knownForLabel;
  const _ListItems({
    required this.imgUrl,
    required this.title,
    this.rating = 0,
    this.voteCount = 0,
    this.overview = '',
    required this.type,
    this.knownForDepartment = '',
    this.knownForLabel = '',
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    String displayKnownForDepartment = '';
    if (knownForDepartment.isNotEmpty) {

      KnownForDepartment departmentEnum = parseKnownForDepartment(knownForDepartment);

      displayKnownForDepartment = departmentEnum.toLocalizedString(context);
    }
    
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: size.width * 0.25,
              child: LoadImage(url: imgUrl, h: 130, w: 110),
            ),
            SizedBox(
              width: size.width * 0.67,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
      
                  if (type != 'Persona') ...[
                    SizedBox(height: 10),
      
                    Row(
                      children: [
                        StarsRatingBarWithInfo(
                          rating: rating * 0.5,
                          iconSize: 12,
                          voteCount: voteCount,
                        ),
                        SizedBox(width: 5.0),
                        Text('- $type', style: TextStyle(fontSize: 11.0)),
                      ],
                    ),
                  ],
      
                  SizedBox(height: 10),
      
                  if (overview.isNotEmpty) ...[
                    Text(overview, overflow: TextOverflow.ellipsis, maxLines: 3),
                    SizedBox(height: 10.0),
                  ],
      
                  if (knownForDepartment.isNotEmpty)
                    Text('$knownForLabel: $displayKnownForDepartment'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
