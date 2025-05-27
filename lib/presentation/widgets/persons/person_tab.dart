import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class PersonTab extends ConsumerWidget {
  final List<Person> persons;
  const PersonTab({super.key, required this.persons});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _PersonTabContent(persons: persons);
  }
}

class _PersonTabContent extends ConsumerStatefulWidget {
  final List<Person> persons;
  const _PersonTabContent({required this.persons});

  @override
  ConsumerState<_PersonTabContent> createState() => _TabState();
}

class _TabState extends ConsumerState<_PersonTabContent>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _onTabChanged(List<Person> persons) {
    if (_tabController!.indexIsChanging) return;

    final index = _tabController!.index;
    final personId = persons[index].id.toString();

    final moviesState = ref.read(moviesByPersonProvider(personId));
    final tvState = ref.read(tvShowsByPersonProvider(personId));

    if (moviesState.visibleMovies.isEmpty) {
      ref.read(moviesByPersonProvider(personId).notifier).loadMoreLocally();
    }

    if (tvState.visibleShows.isEmpty) {
      ref.read(tvShowsByPersonProvider(personId).notifier).loadMoreLocally();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.persons.isEmpty) {
      return SizedBox(
        height: 50,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 1)),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController == null ||
          _tabController!.length != widget.persons.length) {
        final oldIndex = _tabController?.index ?? 0;
        _tabController?.dispose();

        setState(() {
          _tabController = TabController(
            length: widget.persons.length,
            vsync: this,
            initialIndex: oldIndex.clamp(0, widget.persons.length - 1),
          );
          _tabController!.addListener(() => _onTabChanged(widget.persons));
        });

        // Precarga para el primer actor
        final firstId = widget.persons[0].id;
        ref
            .read(moviesByPersonProvider(firstId.toString()).notifier)
            .loadMoreLocally();
        ref
            .read(tvShowsByPersonProvider(firstId.toString()).notifier)
            .loadMoreLocally();
      }
    });

    if (_tabController == null) {
      return const SizedBox(
        height: 500,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
      );
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: _tabController!,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.zero,
            indicatorWeight: 1.0,
            indicatorAnimation: TabIndicatorAnimation.elastic,
            labelColor: Colors.white,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            tabs:
                widget.persons.map((person) {
                  return _circleProfileImg(context, person);
                }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 290,
          child: TabBarView(
            controller: _tabController!,
            children:
                widget.persons.map((person) {
                  return _InfoTab(personId: person.id, type: 'Movie');
                }).toList(),
          ),
        ),
        SizedBox(
          height: 278,
          child: TabBarView(
            controller: _tabController!,
            children:
                widget.persons.map((person) {
                  return _InfoTab(personId: person.id, type: 'TVShow');
                }).toList(),
          ),
        ),
      ],
    );
  }
}

Widget _circleProfileImg(BuildContext context, Person person) {
  person.uniqueID = '${person.id}-actorTrending';

  return GestureDetector(
    onLongPress: () {
      context.pushNamed(PersonScreen.name, extra: person);
    },
    child: SizedBox(
      width: 100,
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              Hero(
                tag: person.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: LoadImage(url: person.profilePath!, w: 100, h: 100),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 10,
                child: FavLikeButtonConsumer(data: person, type: 'Person'),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(person.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );
}

class _InfoTab extends ConsumerWidget {
  final String type;
  final int personId;

  const _InfoTab({required this.type, required this.personId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMovie = type == 'Movie';

    if (isMovie) {
      final moviesState = ref.watch(
        moviesByPersonProvider(personId.toString()),
      );
      final moviesNotifier = ref.read(
        moviesByPersonProvider(personId.toString()).notifier,
      );

      if (moviesState.isLoading && moviesState.visibleMovies.isEmpty) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 1));
      }

      if (!moviesState.isLoading && moviesState.visibleMovies.isEmpty) {
        return Center(child: Text(AppLocalizations.of(context)!.noMoviesFound));
      }

      return SliderHorizontalListview(
        allData: moviesState.visibleMovies,
        type: type,
        title: AppLocalizations.of(context)!.movies,
        onEndReached: () {
          moviesNotifier.loadMoreLocally();
        },
      );
    } else {
      final tvState = ref.watch(tvShowsByPersonProvider(personId.toString()));
      final tvNotifier = ref.read(
        tvShowsByPersonProvider(personId.toString()).notifier,
      );

      if (tvState.isLoading && tvState.visibleShows.isEmpty) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 1));
      }

      if (!tvState.isLoading && tvState.visibleShows.isEmpty) {
        return Center(
          child: Text(AppLocalizations.of(context)!.noTVShowsFound),
        );
      }

      return SliderHorizontalListview(
        allData: tvState.visibleShows,
        type: type,
        title: AppLocalizations.of(context)!.tvShows,
        onEndReached: () {
          tvNotifier.loadMoreLocally();
        },
      );
    }
  }
}
