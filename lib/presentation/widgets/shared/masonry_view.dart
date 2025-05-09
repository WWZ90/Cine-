import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class MasonryView extends StatefulWidget {
  final List<dynamic> data;
  final VoidCallback? loadNextPage;
  const MasonryView({required this.data, this.loadNextPage, super.key});

  @override
  State<MasonryView> createState() => _MasonryViewState();
}

class _MasonryViewState extends State<MasonryView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 400) >
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
    return Container(
      color: Color.fromARGB(255, 19, 19, 19),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: MasonryGridView.count(
          controller: scrollController,
          itemCount: widget.data.length,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          shrinkWrap: true,
          physics:
              const ClampingScrollPhysics(), // o ClampingScrollPhysics() si prefieres Android
          itemBuilder: (context, index) {
            if (index == 1) {
              return Column(
                children: [
                  SizedBox(height: 15),
                  FavoritePosterLink(favorite: widget.data[index]),
                ],
              );
            }
            return FavoritePosterLink(favorite: widget.data[index]);
          },
        ),
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
        } else {
          context.pushNamed(
            PersonScreen.name,
            extra: {
              'id': favorite.id,
              'name': favorite.name,
              'profilePath': favorite.profilePath,
              'popularity': favorite.popularity,
            },
          );
        }
      },
      child: FadeInUp(
        child: Stack(
          children: [
            LoadImage(
              url:
                  favorite is Person
                      ? favorite.profilePath
                      : favorite.posterPath,
              h: 200,
              w: 150,
            ),
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
