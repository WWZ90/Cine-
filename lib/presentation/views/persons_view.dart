import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/presentation/providers/persons/persons_provider.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class PersonsViews extends ConsumerStatefulWidget {
  static const name = 'persons-view';
  const PersonsViews({super.key});

  @override
  ConsumerState<PersonsViews> createState() => _PersonsViewsState();
}

class _PersonsViewsState extends ConsumerState<PersonsViews> {
  @override
  Widget build(BuildContext context) {
    final populars = ref.watch(personPopularProvider);
    //final trending = ref.watch(personTrendingProvider);
    return CustomScrollView(
      slivers: [
        CustomAppbar(),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                TopSlideShow(allData: populars.persons, type: 'Person'),
                SizedBox(height: 20),
                PersonTab(persons: populars.persons),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
