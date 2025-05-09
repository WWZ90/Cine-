import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                                type: 'Person',
                              ),
                            ],
                          ),
                          FavLikeButtonConsumer(
                            data: basePerson,
                            type: 'Person',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: personState.when(
                loading:
                    () => SizedBox(
                      height: 300,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                error:
                    (e, _) => Center(child: Text('Error loading details: $e')),
                data:
                    (person) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((person.birthday != null) ||
                            (person.placeOfBirth.isNotEmpty))
                          Card(
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
                                          Text(
                                            'Fecha de nacimiento: ${formatDate(person.birthday!)}',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                        if (person.placeOfBirth.isNotEmpty)
                                          Text(
                                            'Lugar de nacimiento: ${person.placeOfBirth}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if ((person.birthday != null) ||
                            (person.placeOfBirth.isNotEmpty))
                          SizedBox(height: 10),
                        if (person.biography.isNotEmpty)
                          Column(
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
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.justify,
                                ),
                                secondChild: Text(
                                  person.biography,
                                  style: Theme.of(context).textTheme.bodyLarge,
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
                                    _isExpanded ? 'Ver menos' : 'Ver más',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        _PersonMoviesSection(personId: person.id),
                        _PersonTVShowsSection(personId: person.id),
                      ],
                    ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class _PersonMoviesSection extends ConsumerWidget {
  final int personId;
  const _PersonMoviesSection({required this.personId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesState = ref.watch(moviesByPersonProvider(personId.toString()));

    if (moviesState.isLoading && moviesState.movies.isEmpty) {
      return SizedBox(
        height: 300,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (!moviesState.isLoading && moviesState.movies.isEmpty) {
      return const Center(child: Text('No movies found'));
    }

    return SliderHorizontalListview(
      allData: moviesState.movies,
      type: 'Movie',
      title: 'Películas',
    );
  }
}

class _PersonTVShowsSection extends ConsumerWidget {
  final int personId;
  const _PersonTVShowsSection({required this.personId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tvState = ref.watch(tvShowsByPersonProvider(personId.toString()));

    if (tvState.isLoading && tvState.shows.isEmpty) {
      return SizedBox(
        height: 300,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (!tvState.isLoading && tvState.shows.isEmpty) {
      return const Center(child: Text('No TV shows found'));
    }

    return SliderHorizontalListview(
      allData: tvState.shows,
      type: 'TVShow',
      title: 'Series',
    );
  }
}
