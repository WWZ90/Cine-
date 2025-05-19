import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/config/helpers/date_format.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/infrastructure/models/moviedb/person_moviedb.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class PersonScreen extends ConsumerStatefulWidget {
  static const name = 'person-screen';
  final int id;
  final String personName;
  final String profilePath;
  final double popularity;
  const PersonScreen({
    super.key,
    required this.id,
    required this.personName,
    required this.profilePath,
    required this.popularity,
  });

  @override
  ConsumerState<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends ConsumerState<PersonScreen> {
  late final Person basePerson;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    basePerson = Person(
      id: widget.id,
      name: widget.personName,
      profilePath: widget.profilePath,
      popularity: widget.popularity,
      adult: false,
      gender: 0,
      mediaType: MediaType.PERSON,
      originalName: widget.personName,
      knownForDepartment: KnownForDepartment.ACTING,
    );
    ref.read(personDetailsProvider(widget.id).notifier);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final personState = ref.watch(personDetailsProvider(widget.id));
    final size = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: false,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          expandedHeight: 400,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final collapsed =
                  constraints.maxHeight <=
                  kToolbarHeight + MediaQuery.of(context).padding.top;

              return Stack(
                fit: StackFit.expand,
                children: [
                  LoadImage(
                    h: size.height * 0.55,
                    w: double.infinity,
                    url: widget.profilePath,
                  ),
                  GradientImageBackground(),

                  // 🔙 Back Button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 10,
                    child: Material(
                      color: const Color.fromRGBO(0, 0, 0, 0.5),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),

                  // ✅ Nombre solo visible cuando está colapsado
                  if (collapsed)
                    Positioned(
                      left: 60,
                      bottom: 16,
                      child: Text(
                        widget.personName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  // 📦 Nombre + rating (cuando expandido)
                  if (!collapsed)
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Text(
                                  widget.personName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              StarsRatingBarWithInfo(
                                rating: widget.popularity,
                                voteCount: 0,
                                type: AppLocalizations.of(context)!.person,
                              ),
                            ],
                          ),
                          FavLikeButtonConsumer(
                            data: basePerson,
                            type: AppLocalizations.of(context)!.person,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            personState.when(
              loading:
                  () => SizedBox(
                    height: 300,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              error: (e, _) => Center(child: Text('Error loading details: $e')),
              data:
                  (person) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((person.birthday != null) ||
                          (person.placeOfBirth.isNotEmpty))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Card(
                            color: const Color(0xFF1C1F26),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Colors.blueGrey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (person.birthday != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                            ),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${AppLocalizations.of(context)!.birthday}: ',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: formatDateNew(
                                                      context,
                                                      person.birthday!,
                                                    ),
                                                    style: textStyle.bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        if (person.placeOfBirth.isNotEmpty)
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${AppLocalizations.of(context)!.placeOfBirth}: ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: person.placeOfBirth,
                                                  style: textStyle.bodyMedium
                                                      ?.copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if ((person.birthday != null) ||
                          (person.placeOfBirth.isNotEmpty))
                        SizedBox(height: 10),
                      if (person.biography.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 300),
                                crossFadeState:
                                    _isExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                firstChild: Text(
                                  person.biography,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.justify,
                                ),
                                secondChild: Text(
                                  person.biography,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed:
                                      () => setState(
                                        () => _isExpanded = !_isExpanded,
                                      ),
                                  child: Text(
                                    _isExpanded
                                        ? AppLocalizations.of(context)!.viewLess
                                        : AppLocalizations.of(
                                          context,
                                        )!.viewMore,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 290,
                        child: _PersonMoviesSection(personId: person.id),
                      ),
                      SizedBox(
                        height: 278,
                        child: _PersonTVShowsSection(personId: person.id),
                      ),
                    ],
                  ),
            ),
          ]),
        ),
      ],
    );
  }
}

class _PersonMoviesSection extends ConsumerStatefulWidget {
  final int personId;
  const _PersonMoviesSection({required this.personId});

  @override
  ConsumerState<_PersonMoviesSection> createState() =>
      _PersonMoviesSectionState();
}

class _PersonMoviesSectionState extends ConsumerState<_PersonMoviesSection> {
  @override
  Widget build(BuildContext context) {
    final moviesState = ref.watch(
      moviesByPersonProvider(widget.personId.toString()),
    );

    final notifier = ref.read(
      moviesByPersonProvider(widget.personId.toString()).notifier,
    );

    if (moviesState.isLoading && moviesState.visibleMovies.isEmpty) {
      return Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (!moviesState.isLoading && moviesState.visibleMovies.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noMoviesFound));
    }

    return SliderHorizontalListview(
      allData: moviesState.visibleMovies,
      type: 'Movie',
      title: AppLocalizations.of(context)!.movies,
      onEndReached: () {
        notifier.loadMoreLocally();
      },
    );
  }
}

class _PersonTVShowsSection extends ConsumerStatefulWidget {
  final int personId;
  const _PersonTVShowsSection({required this.personId});

  @override
  ConsumerState<_PersonTVShowsSection> createState() =>
      _PersonTVShowsSectionState();
}

class _PersonTVShowsSectionState extends ConsumerState<_PersonTVShowsSection> {
  @override
  Widget build(BuildContext context) {
    final tvShowState = ref.watch(
      tvShowsByPersonProvider(widget.personId.toString()),
    );

    final notifier = ref.read(
      tvShowsByPersonProvider(widget.personId.toString()).notifier,
    );

    if (tvShowState.isLoading && tvShowState.visibleShows.isEmpty) {
      return Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (!tvShowState.isLoading && tvShowState.visibleShows.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noTVShowsFound));
    }

    return SliderHorizontalListview(
      allData: tvShowState.visibleShows,
      type: 'TVShow',
      title: AppLocalizations.of(context)!.tvShows,
      onEndReached: () {
        notifier.loadMoreLocally();
      },
    );
  }
}
