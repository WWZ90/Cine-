import 'package:animate_do/animate_do.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonTab extends ConsumerWidget {
  const PersonTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persons = ref.watch(personPopularProvider);

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
  late final ScrollController _tabBarScrollController;
  List<Person> _previousPersons = [];

  @override
  void initState() {
    super.initState();
    _tabBarScrollController = ScrollController();
    _tabBarScrollController.addListener(_onTabBarScrolled);

    _previousPersons = widget.persons;

    _tabController = TabController(length: widget.persons.length, vsync: this);
    _tabController!.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firstId = widget.persons[0].id;
      ref
          .read(moviesByPersonProvider(firstId.toString()).notifier)
          .loadNextPage();
      ref
          .read(tvShowsByPersonProvider(firstId.toString()).notifier)
          .loadNextPage();
    });
  }

  void _onTabBarScrolled() {
    if (_tabBarScrollController.position.pixels >=
        _tabBarScrollController.position.maxScrollExtent - 100) {
      ref.read(personPopularProvider.notifier).loadNextPage();
    }
  }

  @override
  void didUpdateWidget(covariant _PersonTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.persons.length != _previousPersons.length) {
      _previousPersons = widget.persons;

      final oldIndex = _tabController?.index ?? 0;
      _tabController?.dispose();

      _tabController = TabController(
        length: widget.persons.length,
        vsync: this,
        initialIndex: oldIndex.clamp(0, widget.persons.length - 1),
      );
      _tabController!.addListener(_onTabChanged);
    }
  }

  void _onTabChanged() {
    if (_tabController!.indexIsChanging) return;

    final index = _tabController!.index;

    final personId = widget.persons[index].id;
    ref
        .read(moviesByPersonProvider(personId.toString()).notifier)
        .loadNextPage();
    ref
        .read(tvShowsByPersonProvider(personId.toString()).notifier)
        .loadNextPage();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _tabBarScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _tabBarScrollController,
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
                  widget.persons.map((Person person) {
                    return _circleProfileImg(context, person);
                  }).toList(),
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: TabBarView(
            controller: _tabController!,
            children:
                widget.persons.map((person) {
                  return _InfoTab(personId: person.id, type: 'Movie');
                }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
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
      // Navegación futura
    },
    child: SizedBox(
      width: 100,
      child: Column(
        children: <Widget>[
          Hero(
            tag: person.id,
            child: FadeInRight(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: LoadImage(url: person.profilePath!, w: 100, h: 100),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
      );
    } else {
      final tvState = ref.watch(tvShowsByPersonProvider(personId.toString()));

      if (tvState.isLoading && tvState.shows.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!tvState.isLoading && tvState.shows.isEmpty) {
        return const Center(child: Text('No TV shows'));
      }

      return SliderHorizontalListview(allData: tvState.shows, type: 'TVShow');
    }
  }
}
