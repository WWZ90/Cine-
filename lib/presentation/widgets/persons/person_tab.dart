import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/domain/entities/person.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class PersonTab extends ConsumerWidget {
  const PersonTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _PersonTabContent();
  }
}

class _PersonTabContent extends ConsumerStatefulWidget {
  const _PersonTabContent();

  @override
  ConsumerState<_PersonTabContent> createState() => _TabState();
}

class _TabState extends ConsumerState<_PersonTabContent> {
  int _selectedIndex = 0;
  final ScrollController _tabsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabsScrollController.addListener(_onTabsScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final popularPersonsState = ref.read(personPopularProvider);
      if (popularPersonsState.persons.isEmpty &&
          !popularPersonsState.isLoading) {
        ref.read(personPopularProvider.notifier).loadNextPage().then((_) {
          if (mounted) {
            final updatedState = ref.read(personPopularProvider);
            if (updatedState.persons.isNotEmpty) {
              _preloadDataForSelectedPerson(0, updatedState.persons);
            }
          }
        });
      } else if (popularPersonsState.persons.isNotEmpty) {
        _preloadDataForSelectedPerson(
          _selectedIndex,
          popularPersonsState.persons,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabsScrollController.removeListener(_onTabsScroll);
    _tabsScrollController.dispose();
    super.dispose();
  }

  void _onTabsScroll() {
    if (!mounted) return;
    if (_tabsScrollController.position.pixels >=
            _tabsScrollController.position.maxScrollExtent - 200 &&
        !ref.read(personPopularProvider).isLoading) {
      ref.read(personPopularProvider.notifier).loadNextPage();
    }
  }

  void _onPersonTabTap(int index, List<Person> currentPersons) {
    if (index < 0 || index >= currentPersons.length) {
      return;
    }
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
    _preloadDataForSelectedPerson(index, currentPersons);
  }

  void _preloadDataForSelectedPerson(
    int personIndex,
    List<Person> currentPersons,
  ) {
    if (!mounted || personIndex < 0 || personIndex >= currentPersons.length) {
      return;
    }

    final personId = currentPersons[personIndex].id.toString();

    final moviesState = ref.read(moviesByPersonProvider(personId));
    if (moviesState.visibleMovies.isEmpty && !moviesState.isLoading) {
      ref.read(moviesByPersonProvider(personId).notifier).loadMoreLocally();
    }

    // Precargar series
    final tvState = ref.read(tvShowsByPersonProvider(personId));
    if (tvState.visibleShows.isEmpty && !tvState.isLoading) {
      ref.read(tvShowsByPersonProvider(personId).notifier).loadMoreLocally();
    }
  }

  @override
  Widget build(BuildContext context) {
    final popularPersonsState = ref.watch(personPopularProvider);
    final List<Person> currentPersons = popularPersonsState.persons;
    final bool isLoadingInitialPersons =
        popularPersonsState.isLoading && currentPersons.isEmpty;
    final bool isLoadingMorePersons =
        popularPersonsState.isLoading && currentPersons.isNotEmpty;

    if (isLoadingInitialPersons) {
      return const SizedBox(
        height: 130,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    int effectiveSelectedIndex = _selectedIndex;
    if (currentPersons.isNotEmpty) {
      if (_selectedIndex >= currentPersons.length) {
        effectiveSelectedIndex = currentPersons.length - 1;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _selectedIndex != effectiveSelectedIndex) {
            setState(() {
              _selectedIndex = effectiveSelectedIndex;
            });
            _preloadDataForSelectedPerson(
              effectiveSelectedIndex,
              currentPersons,
            );
          }
        });
      }
    } else {
      effectiveSelectedIndex = 0;
    }

    final Person? selectedPersonToShowContent =
        (currentPersons.isNotEmpty &&
                effectiveSelectedIndex < currentPersons.length)
            ? currentPersons[effectiveSelectedIndex]
            : null;

    return Column(
      children: [
        SizedBox(
          height: 130,
          child: ListView.builder(
            key: const ValueKey('person_tabs_list_view'),
            controller: _tabsScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: currentPersons.length + (isLoadingMorePersons ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == currentPersons.length && isLoadingMorePersons) {
                return const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 40.0,
                    horizontal: 20.0,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              if (index >= currentPersons.length) {
                return const SizedBox.shrink();
              }

              final person = currentPersons[index];
              final bool isSelected = index == effectiveSelectedIndex;
              return _CircleProfileTabItem(
                person: person,
                isSelected: isSelected,
                onTap: () => _onPersonTabTap(index, currentPersons),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        if (selectedPersonToShowContent != null) ...[
          _InfoTab(person: selectedPersonToShowContent, type: 'Movie'),
          const SizedBox(height: 10),
          _InfoTab(person: selectedPersonToShowContent, type: 'TVShow'),
        ] else if (currentPersons.isNotEmpty && !isLoadingInitialPersons) ...[
          const Expanded(child: Center(child: Text("Seleccione una persona"))),
        ],
      ],
    );
  }
}

class _CircleProfileTabItem extends StatelessWidget {
  final Person person;
  final bool isSelected;
  final VoidCallback onTap;

  const _CircleProfileTabItem({
    required this.person,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    person.uniqueID = 'personTabItem_${person.id}_${person.name}';
    final String uniqueHeroTag = person.uniqueID!;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        context.pushNamed(PersonScreen.name, extra: person);
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          border:
              isSelected
                  ? Border(
                    bottom: BorderSide(
                      color: Theme.of(context).indicatorColor,
                      width: 2.0,
                    ),
                  )
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Hero(
                  tag: uniqueHeroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LoadImage(url: person.profilePath!, w: 90, h: 90),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: FavLikeButtonConsumer(
                    data: person,
                    type: 'Person',
                    iconSize: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              person.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTab extends ConsumerWidget {
  final String type;
  final Person person;

  const _InfoTab({required this.type, required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMovie = type == 'Movie';
    final l10n = AppLocalizations.of(context)!;

    String actorActressLabel = l10n.asActor;
    int? gender = person.gender;

    if (gender == 1) {
      actorActressLabel = l10n.asActress;
    } else if (gender == 2) {
      actorActressLabel = l10n.asActor;
    } else {
      actorActressLabel = l10n.asActorActress;
    }

    String moviesAsCastTitle = l10n.moviesAs(actorActressLabel);
    String tvShowsAsCastTitle = l10n.tvShowsAs(actorActressLabel);

    Widget content;

    if (isMovie) {
      final moviesState = ref.watch(
        moviesByPersonProvider(person.id.toString()),
      );
      if (moviesState.isLoading && moviesState.visibleMovies.isEmpty) {
        content = const SizedBox(
          height: 290,
          child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
        );
      } else if (!moviesState.isLoading && moviesState.visibleMovies.isEmpty) {
        content = SizedBox(
          height: 290,
          child: Center(child: Text(l10n.noMoviesFound)),
        );
      } else {
        content = SizedBox(
          height: 290,
          child: SliderHorizontalListview(
            allData: moviesState.visibleMovies,
            type: 'Movie',
            title: moviesAsCastTitle,
            onEndReached: () {
              ref
                  .read(moviesByPersonProvider(person.id.toString()).notifier)
                  .loadMoreLocally();
            },
          ),
        );
      }
    } else {
      // TVShow
      final tvState = ref.watch(tvShowsByPersonProvider(person.id.toString()));
      if (tvState.isLoading && tvState.visibleShows.isEmpty) {
        content = const SizedBox(
          height: 278,
          child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
        );
      } else if (!tvState.isLoading && tvState.visibleShows.isEmpty) {
        content = SizedBox(
          height: 278,
          child: Center(child: Text(l10n.noTVShowsFound)),
        );
      } else {
        content = SizedBox(
          height: 278,
          child: SliderHorizontalListview(
            allData: tvState.visibleShows,
            type: 'TVShow',
            title: tvShowsAsCastTitle,
            onEndReached: () {
              ref
                  .read(tvShowsByPersonProvider(person.id.toString()).notifier)
                  .loadMoreLocally();
            },
          ),
        );
      }
    }
    return content;
  }
}
