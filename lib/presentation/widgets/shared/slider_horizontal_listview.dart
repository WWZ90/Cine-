import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:animate_do/animate_do.dart';
import 'package:cinemania/presentation/screens/movies/movie_screen.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:cinemania/presentation/screens/tv_shows/tv_show_screen.dart';

class SliderHorizontalListview extends ConsumerStatefulWidget {
  final List<dynamic> allData;
  final String? title;
  final String? subTitle;
  final String type;

  final VoidCallback? loadNextPage;

  const SliderHorizontalListview({
    super.key,
    required this.allData,
    this.title,
    this.subTitle,
    required this.type,
    this.loadNextPage,
  });

  @override
  ConsumerState<SliderHorizontalListview> createState() =>
      _SliderHorizontalListviewState();
}

class _SliderHorizontalListviewState
    extends ConsumerState<SliderHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >=
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
    return SizedBox(
      height: 311,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(
              title: widget.title,
              subTitle: widget.subTitle,
              type: widget.type,
            ),
          SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: widget.allData.length,
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final data = widget.allData[index];
                data.uniqueID =
                    '${data.id}-${widget.type}-section-${widget.title}';
                return FadeInRight(
                  child: Stack(
                    children: [
                      _Slide(data: data, type: widget.type),
                      Positioned(
                        bottom: 55,
                        right: 10,
                        child: FavLikeButtonConsumer(
                          data: data,
                          type: widget.type,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? type;

  const _Title({this.title, this.subTitle, required this.type});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return Container(
      padding: EdgeInsets.only(top: 20),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null) Text(title!, style: titleStyle),

          Spacer(),

          if (subTitle != null)
            FilledButton.tonal(
              onPressed: () {
                final String t = '$title-$type';
                context.pushNamed('masonry-all-view', extra: t);
              },
              style: ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text('Ver Todo'),
            ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final dynamic data;
  final String type;
  const _Slide({required this.data, required this.type});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (type == 'Movie') {
                context.pushNamed(MovieScreen.name, extra: data);
              }
              if (type == 'TVShow') {
                context.pushNamed(TVShowScreen.name, extra: data);
              }
            },
            child: SizedBox(
              height: 195,
              width: 150,
              child: Hero(
                tag: data.uniqueID.toString(),
                child: LoadImage(url: data.posterPath, h: 200, w: 150),
              ),
            ),
          ),

          SizedBox(height: 5),

          //*Title
          SizedBox(
            width: 150,
            child: Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle.titleSmall,
            ),
          ),

          StarsRatingBarWithInfo(
            rating: data.voteAverage,
            voteCount: data.voteCount,
            iconSize: 11,
            color: Colors.yellow.shade600,
          ),
        ],
      ),
    );
  }
}
