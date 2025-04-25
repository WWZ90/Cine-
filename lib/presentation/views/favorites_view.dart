import 'package:animate_do/animate_do.dart';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

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
              'No favorites at the moment',
              style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 141, 141, 141)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: FavoritesMasonry(loadNextPage: loadNextPage, favorites: favorites),
    );
  }
}

class FavoritesMasonry extends StatefulWidget {
  final List<dynamic> favorites;
  final VoidCallback? loadNextPage;
  const FavoritesMasonry({
    required this.favorites,
    this.loadNextPage,
    super.key,
  });

  @override
  State<FavoritesMasonry> createState() => _FavoritesMasonryState();
}

class _FavoritesMasonryState extends State<FavoritesMasonry> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        itemCount: widget.favorites.length,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                SizedBox(height: 15),
                FavoritePosterLink(favorite: widget.favorites[index]),
              ],
            );
          }
          return FavoritePosterLink(favorite: widget.favorites[index]);
        },
      ),
    );
  }
}

class FavoritePosterLink extends StatelessWidget {
  final dynamic favorite;
  const FavoritePosterLink({required this.favorite, super.key});

  @override
  Widget build(BuildContext context) {
    String type = '';
    if (favorite is Movie) {
      type = 'Movie';
    } else if (favorite is TVShow) {
      type = 'TVShow';
    }
    return GestureDetector(
      onTap: () {
        if (favorite is Movie) {
          context.pushNamed(MovieScreen.name, extra: favorite as Movie);
        } else if (favorite is TVShow) {
          context.pushNamed(TVShowScreen.name, extra: favorite as TVShow);
        }
      },
      child: FadeInUp(
        child: Stack(
          children: [
            LoadImage(url: favorite.posterPath, h: 200, w: 150),
            Positioned(
              bottom: 4,
              right: 4,
              child: FavLikeButtonConsumer(data: favorite, type: type),
            ),
          ],
        ),
      ),
    );
  }
}
