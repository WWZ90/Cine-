import 'package:animate_do/animate_do.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PersonTab extends ConsumerWidget {
  const PersonTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persons = ref.watch(curatedActorsProvider);
    return _PersonTabContent(persons: persons);
  }
}

class _PersonTabContent extends ConsumerStatefulWidget {
  final AsyncValue<List<Person>> persons;
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

    if (moviesState.movies.isEmpty) {
      ref.read(moviesByPersonProvider(personId).notifier).loadNextPage();
    }

    if (tvState.shows.isEmpty) {
      ref.read(tvShowsByPersonProvider(personId).notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.persons.when(
      loading:
          () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (persons) {
        if (persons.isEmpty) {
          return const Center(child: Text('No actors found.'));
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_tabController == null ||
              _tabController!.length != persons.length) {
            final oldIndex = _tabController?.index ?? 0;
            _tabController?.dispose();

            setState(() {
              _tabController = TabController(
                length: persons.length,
                vsync: this,
                initialIndex: oldIndex.clamp(0, persons.length - 1),
              );
              _tabController!.addListener(() => _onTabChanged(persons));
            });

            // Precarga para el primer actor
            final firstId = persons[0].id;
            ref
                .read(moviesByPersonProvider(firstId.toString()).notifier)
                .loadNextPage();
            ref
                .read(tvShowsByPersonProvider(firstId.toString()).notifier)
                .loadNextPage();
          }
        });

        if (_tabController == null) {
          return const SizedBox(
            height: 500,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
                labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                tabs:
                    persons.map((person) {
                      return _circleProfileImg(context, person);
                    }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 295,
              child: TabBarView(
                controller: _tabController!,
                children:
                    persons.map((person) {
                      return _InfoTab(personId: person.id, type: 'Movie');
                    }).toList(),
              ),
            ),
            SizedBox(
              height: 295,
              child: TabBarView(
                controller: _tabController!,
                children:
                    persons.map((person) {
                      return _InfoTab(personId: person.id, type: 'TVShow');
                    }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _circleProfileImg(BuildContext context, Person person) {
  person.uniqueID = '${person.id}-actorTrending';

  return GestureDetector(
    onLongPress: () {
      context.pushNamed(
        PersonScreen.name,
        extra: {
          'id': person.id,
          'name': person.name,
          'profilePath': person.profilePath,
          'popularity': person.popularity,
        },
      );
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
    if (type == 'Movie') {
      final moviesState = ref.watch(
        moviesByPersonProvider(personId.toString()),
      );

      if (moviesState.isLoading && moviesState.movies.isEmpty) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      }

      if (!moviesState.isLoading && moviesState.movies.isEmpty) {
        return const Center(child: Text('No movies'));
      }

      return SliderHorizontalListview(
        allData: moviesState.movies,
        type: 'Movie',
        title: 'Sus Películas',
      );
    } else {
      final tvState = ref.watch(tvShowsByPersonProvider(personId.toString()));

      if (tvState.isLoading && tvState.shows.isEmpty) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      }

      if (!tvState.isLoading && tvState.shows.isEmpty) {
        return const Center(child: Text('No TV shows'));
      }

      return SliderHorizontalListview(
        allData: tvState.shows,
        type: 'TVShow',
        title: 'Sus Series',
      );
    }
  }
}
