import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class FavoritesView extends ConsumerStatefulWidget {
  static const name = 'favorites-view';
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {
  @override
  void initState() {
    super.initState();
    ref.read(favoritesProvider.notifier).loadNextPage();
  }

  bool isLastPage = false;
  bool isLoading = false;

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;
    final favorites = await ref.read(favoritesProvider.notifier).loadNextPage();
    isLoading = false;
    if (favorites.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic favorites = ref.watch(favoritesProvider).values.toList();

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_outlined, size: 40, color: Colors.red,),
            Text(
              'Ohh no!!!',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            Text(
              'No tienes favoritos actualmente...',
              style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 141, 141, 141)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: MasonryView(loadNextPage: loadNextPage, data: favorites),
    );
  }
}