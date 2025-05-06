import 'package:cinemania/presentation/providers/persons/persons_provider.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return CustomScrollView(
      slivers: [
        CustomAppbar(),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [TopSlideShow(allData: populars, type: 'Person')],
            );
          }, childCount: 1),
        )
      ],
    );
  }
}
