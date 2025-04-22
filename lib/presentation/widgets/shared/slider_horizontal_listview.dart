import 'package:animate_do/animate_do.dart';
import 'package:cinemania/presentation/screens/movies/movie_screen.dart';
import 'package:cinemania/presentation/screens/tv_shows/tv_show_screen.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SliderHorizontalListview extends StatefulWidget {
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
  State<SliderHorizontalListview> createState() =>
      _SliderHorizontalListviewState();
}

class _SliderHorizontalListviewState extends State<SliderHorizontalListview> {
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
      height: 306,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle),
          SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: widget.allData.length,
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                widget.allData[index].uniqueID =
                    '${widget.allData[index].id}-"${widget.type}-section"-${widget.title}';
                return FadeInRight(
                  child: _Slide(data: widget.allData[index], type: widget.type),
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

  const _Title({this.title, this.subTitle});

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
              onPressed: () {},
              style: ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text(subTitle!),
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

                /*ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: NetworkToFileImage(
                      url: movie.posterPath,
                      file: LocalImageFileManager.fileFromUrl(
                        movie.posterPath,
                      ),
                      debug: true,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),*/
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
