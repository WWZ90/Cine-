import 'dart:async';
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:cinemania/domain/entities/search.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

typedef SearchCallback = Future<List<MultiSearch>> Function(String query);

class MultiSearchDelegate extends SearchDelegate<MultiSearch?> {
  StreamController<List<MultiSearch>> debouncedMultiSearch =
      StreamController.broadcast();

  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  final SearchCallback search;
  List<MultiSearch> initialSearchs;

  MultiSearchDelegate({required this.search, required this.initialSearchs})
    : super(
        searchFieldLabel: 'Busca películas, series, actores...',
        searchFieldStyle: TextStyle(fontSize: 18),
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
            onSelected: (context, searchs) {
              clearStreams();
              close(context, searchs);
            },
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
        // Elimina el espacio que hay entre el leading y el title
        titleSpacing: 0,
        // opcional: ajusta la altura si hace falta
        //toolbarHeight: 56,
      ),
      // Quita el padding interno del TextField
      inputDecorationTheme: const InputDecorationTheme(
        // ANULA cualquier borde
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        // quita padding interno
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
  const _SearchsItems({required this.searchs, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: ListView(
        children:
            searchs!.map((response) {
              if (response.mediaType == "movie") {
                return GestureDetector(
                  child: _ListItems(
                    type: 'Película',
                    imgUrl: response.posterPath ?? '',
                    title: response.title ?? '',
                    rating: response.voteAverage ?? '',
                    voteCount: response.voteCount ?? '',
                    overview: response.overview ?? '',
                  ),
                  onTap: () {
                    onSelected(context, response);
                  },
                );
              } else if (response.mediaType == "person") {
                return _ListItems(
                  type: 'Persona',
                  imgUrl: response.profilePath ?? '',
                  title: response.name ?? '',
                  knownForDepartment: response.knownForDepartment ?? '',
                );
              } else if (response.mediaType == "tv") {
                return GestureDetector(
                  child: _ListItems(
                    type: 'Serie',
                    imgUrl: response.posterPath ?? '',
                    title: response.name ?? '',
                    rating: response.voteAverage!,
                    voteCount: response.voteCount ?? '',
                    overview: response.overview ?? '',
                  ),
                  onTap: () {
                    onSelected(context, response);
                  },
                );
              } else {
                return Container(color: ThemeData().primaryColor);
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
  const _ListItems({
    required this.imgUrl,
    required this.title,
    this.rating = 0,
    this.voteCount = 0,
    this.overview = '',
    required this.type,
    this.knownForDepartment = '',
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
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
                  Text(overview, overflow: TextOverflow.ellipsis, maxLines: 4),
                  SizedBox(height: 10.0),
                ],

                if (knownForDepartment.isNotEmpty)
                  Text('Conocido por: $knownForDepartment'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
