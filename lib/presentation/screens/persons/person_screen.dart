import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/config/helpers/date_format.dart';
import 'package:cinemania/config/helpers/ask_for_review_if_needed.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class PersonScreen extends ConsumerStatefulWidget {
  static const name = 'person-screen';
  final Person person;
  const PersonScreen({super.key, required this.person});

  @override
  ConsumerState<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends ConsumerState<PersonScreen> {
  bool _isExpanded = false;
  Timer? _reviewTimer;
  final ScrollController _scrollController = ScrollController();
  bool _personViewMarked = false;
  bool _hasScrolledToEnd = false;
  bool _hasTimeElapsed = false;

  @override
  void initState() {
    super.initState();
    final id = widget.person.id.toString();
    ref.read(personDetailProvider.notifier).loadPerson(id);

    _scrollController.addListener(_onScroll);

    _reviewTimer = Timer(const Duration(seconds: 15), () {
      if (mounted) {
        print("PersonScreen: 15 seconds timer elapsed.");
        _hasTimeElapsed = true;
        _checkConditionsAndMarkView();
      }
    });
  }

  void _onScroll() {
    if (!mounted || _personViewMarked) return;

    final atBottomThreshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.offset >= atBottomThreshold &&
        _scrollController.position.maxScrollExtent > 0) {
      if (!_hasScrolledToEnd) {
        print("PersonScreen: Scrolled near to end.");
        _hasScrolledToEnd = true;
        _checkConditionsAndMarkView();
      }
    }
  }

  void _checkConditionsAndMarkView() {
    if (!mounted || _personViewMarked) return;
    if (_hasScrolledToEnd && _hasTimeElapsed) {
      print(
        "PersonScreen: Both conditions (scroll to end AND time elapsed) met. Marking person view.",
      );
      ReviewFlags.markPersonView();
      _personViewMarked = true; 
      _reviewTimer?.cancel();
      _scrollController.removeListener(
        _onScroll,
      ); 
    } else {
      if (_hasScrolledToEnd)
        print("PersonScreen: Scrolled to end, waiting for time.");
      if (_hasTimeElapsed)
        print("PersonScreen: Time elapsed, waiting for scroll.");
    }
  }

  @override
  void dispose() {
    _reviewTimer?.cancel();
    _scrollController.removeListener(
      _onScroll,
    );
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final PersonDetails? personDetails =
        ref.watch(personDetailProvider)[widget.person.id.toString()];

    final l10n = AppLocalizations.of(context)!;
    String actorActressLabel = l10n.asActor;
    int? gender = widget.person.gender;

    if (gender == 1) {
      actorActressLabel = l10n.asActress;
    } else if (gender == 2) {
      actorActressLabel = l10n.asActor;
    } else {
      actorActressLabel = l10n.asActorActress;
    }

    String moviesAsCastTitle = l10n.moviesAs(actorActressLabel);
    String tvShowsAsCastTitle = l10n.tvShowsAs(actorActressLabel);

    return Container(
      color: Color(0xFF121318),
      child: CustomScrollView(
        controller: _scrollController,
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

                return Hero(
                  tag: widget.person.uniqueID!,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      LoadImage(
                        h: size.height * 0.55,
                        w: double.infinity,
                        url: widget.person.profilePath!,
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
                            widget.person.name,
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
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.80,
                                    child: Text(
                                      widget.person.name,
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
                                    rating: widget.person.popularity,
                                    voteCount: 0,
                                    type: "Person",
                                  ),
                                ],
                              ),
                              FavLikeButtonConsumer(
                                data: widget.person,
                                type: "Person",
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              if (personDetails == null)
                SizedBox(
                  height: 300,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    if ((personDetails.birthday != null) ||
                        (personDetails.placeOfBirth.isNotEmpty))
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
                                      if (personDetails.birthday != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8.0,
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '${l10n.birthday}: ',
                                                  style: textStyle.bodyMedium
                                                      ?.copyWith(
                                                        color: Colors.grey[500],
                                                      ),
                                                ),
                                                TextSpan(
                                                  text: formatDateNew(
                                                    context,
                                                    personDetails.birthday!,
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

                                      if (personDetails.placeOfBirth.isNotEmpty)
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${l10n.placeOfBirth}: ',
                                                style: textStyle.bodyMedium
                                                    ?.copyWith(
                                                      color: Colors.grey[500],
                                                    ),
                                              ),
                                              TextSpan(
                                                text:
                                                    personDetails.placeOfBirth,
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

                    if ((personDetails.birthday != null) ||
                        (personDetails.placeOfBirth.isNotEmpty))
                      SizedBox(height: 10),
                    if (personDetails.biography.isNotEmpty)
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
                                personDetails.biography,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.justify,
                              ),
                              secondChild: Text(
                                personDetails.biography,
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
                                  _isExpanded ? l10n.viewLess : l10n.viewMore,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (personDetails.knownForDepartment != 'Acting')
                      Column(
                        children: [
                          _PersonGroupedCrewWorkSection(
                            personId: personDetails.id,
                          ),
                          _PersonMoviesSection(
                            personId: personDetails.id,
                            title: moviesAsCastTitle,
                          ),
                          _PersonTVShowsSection(
                            personId: personDetails.id,
                            title: tvShowsAsCastTitle,
                          ),
                        ],
                      ),

                    if (personDetails.knownForDepartment == 'Acting')
                      Column(
                        children: [
                          _PersonMoviesSection(
                            personId: personDetails.id,
                            title: moviesAsCastTitle,
                          ),
                          _PersonTVShowsSection(
                            personId: personDetails.id,
                            title: tvShowsAsCastTitle,
                          ),
                          _PersonGroupedCrewWorkSection(
                            personId: personDetails.id,
                          ),
                        ],
                      ),
                  ],
                ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _PersonGroupedCrewWorkSection extends ConsumerWidget {
  final int personId;
  const _PersonGroupedCrewWorkSection({required this.personId});

  static const List<String> sectionOrder = [
    'Director',
    'Producer',
    'Writer',
    'Sound',
    'Other Crew Work',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crewState = ref.watch(
      moviesCrewByPersonGroupedProvider(personId.toString()),
    );

    if (crewState.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 1)),
      );
    }

    if (crewState.groupedMovies.isEmpty && !crewState.isLoading) {
      // Podrías mostrar un mensaje de "No hay trabajos de crew" o simplemente nada
      return SizedBox.shrink();
    }

    List<Widget> sections = [];
    for (String sectionTitleKey in sectionOrder) {
      if (crewState.groupedMovies.containsKey(sectionTitleKey)) {
        final moviesForSection = crewState.groupedMovies[sectionTitleKey]!;
        if (moviesForSection.isNotEmpty) {
          String localizedSectionTitle = getLocalizedCrewSectionTitle(
            context,
            sectionTitleKey,
          );
          sections.add(
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
              child: SizedBox(
                height: 273,
                child: SliderHorizontalListview(
                  title: localizedSectionTitle,
                  allData: moviesForSection,
                  type: 'Movie',
                ),
              ),
            ),
          );
        }
      }
    }

    if (sections.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  String getLocalizedCrewSectionTitle(
    BuildContext context,
    String categoryKey,
  ) {
    final l10n = AppLocalizations.of(context)!;
    switch (categoryKey) {
      case 'Director':
        return l10n.crewRoleDirector;
      case 'Producer':
        return l10n.crewRoleProducer;
      case 'Writer':
        return l10n.crewRoleWriter;
      case 'Sound':
        return l10n.crewRoleSound;
      case 'Other Crew Work':
        return l10n.crewRoleOther;
      default:
        return categoryKey;
    }
  }
}

class _PersonMoviesSection extends ConsumerStatefulWidget {
  final int personId;
  final String title;
  const _PersonMoviesSection({required this.personId, required this.title});

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
      return SizedBox(
        height: 290,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
      );
    }

    if (!moviesState.isLoading && moviesState.visibleMovies.isEmpty) {
      return SizedBox.shrink();
    }

    return SliderHorizontalListview(
      allData: moviesState.visibleMovies,
      type: 'Movie',
      title: widget.title,
      onEndReached: () {
        notifier.loadMoreLocally();
      },
    );
  }
}

class _PersonTVShowsSection extends ConsumerStatefulWidget {
  final int personId;
  final String title;
  const _PersonTVShowsSection({required this.personId, required this.title});

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
      return SizedBox(
        height: 290,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
      );
    }

    if (!tvShowState.isLoading && tvShowState.visibleShows.isEmpty) {
      return SizedBox.shrink();
    }

    return SliderHorizontalListview(
      allData: tvShowState.visibleShows,
      type: 'TVShow',
      title: widget.title,
      onEndReached: () {
        notifier.loadMoreLocally();
      },
    );
  }
}
