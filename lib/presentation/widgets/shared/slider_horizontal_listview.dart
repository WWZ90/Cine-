import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cinemania/presentation/screens/screens.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';


class SliderHorizontalListview extends ConsumerStatefulWidget {
  final List<dynamic> allData;
  final String? title;
  final String? subTitle;
  final String type;
  final bool? isForOscars;
  final dynamic forMovies;
  final String? id; // For movie or tv show id - to get Similars.
  final VoidCallback? onEndReached;

  final VoidCallback? loadNextPage;
  final bool isLoadingMore;

  const SliderHorizontalListview({
    super.key,
    required this.allData,
    this.title,
    this.subTitle,
    required this.type,
    this.loadNextPage,
    this.id = '',
    this.isForOscars = false,
    this.forMovies = '',
    this.onEndReached,
    this.isLoadingMore = false,
  });

  @override
  ConsumerState<SliderHorizontalListview> createState() =>
      _SliderHorizontalListviewState();
}

class _SliderHorizontalListviewState
    extends ConsumerState<SliderHorizontalListview>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      // Detectamos que estamos cerca del final (scroll horizontal)
      final reachedEnd =
          (scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent;

      if (reachedEnd) {
        // Llama a ambos callbacks si están definidos
        if (widget.loadNextPage != null && !widget.isLoadingMore) {
          widget.loadNextPage!();
        }
        if (widget.onEndReached != null) widget.onEndReached!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // _SliderHorizontalListviewState

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double itemWidth = 150; // Ancho de tus _Slide (póster)
    final double itemHeight =
        295; // Altura total aproximada de tu _Slide + texto + estrellas + padding
    final double posterHeight = 193; // Altura del widget LoadImage / póster
    final double posterWidth = 150; // Ancho del widget LoadImage / póster

    return SizedBox(
      height: itemHeight, // Altura total del slider
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(
              title: widget.title,
              subTitle: widget.subTitle,
              type: widget.type,
              id: widget.id,
            ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount:
                  widget.allData.length +
                  (widget.isLoadingMore && widget.allData.isNotEmpty ? 1 : 0),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == widget.allData.length &&
                    widget.isLoadingMore &&
                    widget.allData.isNotEmpty) {
                  // Es el momento de mostrar el indicador de "cargar más"
                  // Lo construimos para que se parezca a un _Slide en términos de espacio,
                  // pero con el loader en la posición del póster.
                  return Container(
                    width: itemWidth, // Mismo ancho que un _Slide
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height:
                              posterHeight, // Misma altura que el área del póster
                          width:
                              posterWidth, // Mismo ancho que el área del póster
                          child: const Center(
                            child: SizedBox(
                              width: 35, // Tamaño del CircularProgressIndicator
                              height: 35,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                              ), // Ajusta el strokeWidth si quieres
                            ),
                          ),
                        ),
                        const SizedBox(height: 5), // Espacio como en _Slide
                        // Placeholders vacíos para el título y estrellas para mantener la altura
                        SizedBox(
                          width:
                              itemWidth, // Mismo ancho que el título en _Slide
                          height:
                              Theme.of(
                                context,
                              ).textTheme.titleSmall!.fontSize! *
                              1.2, // Altura estimada del título
                        ),
                        const SizedBox(height: 4), // Espacio como en _Slide
                        SizedBox(
                          width: itemWidth,
                          height:
                              20, // Altura estimada de StarsRatingBarWithInfo
                        ),
                      ],
                    ),
                  );
                }

                if (index >= widget.allData.length) {
                  return const SizedBox.shrink();
                }

                final data = widget.allData[index];
                // Asegúrate de que uniqueID se maneje correctamente ANTES de llegar aquí
                // Ejemplo: data.uniqueID ??= '${data.id}-${widget.type}-loader'; // O algo similar si es nulo
                data.uniqueID =
                    '${data.id}-${widget.type}-section-${widget.title}-$index';

                final String heroTag =
                    data.uniqueID?.isNotEmpty == true
                        ? data.uniqueID!
                        : '${widget.type}-${data.id}-slider';

                return FadeInRight(
                  key: ValueKey(heroTag),
                  child: _Slide(
                    data: data,
                    type: widget.type,
                    isForOscars: widget.isForOscars,
                    forMovie:
                        widget.isForOscars!
                            ? widget.forMovies[index].title
                            : '',
                  ), // No necesitas Stack aquí si _Slide ya lo maneja
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
  final String? id;

  const _Title({this.title, this.subTitle, required this.type, this.id});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return Container(
      //padding: EdgeInsets.only(top: 20),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null) Text(title!, style: titleStyle),

          Spacer(),

          if (subTitle != null)
            FilledButton.tonal(
              onPressed: () async {
                await Future.delayed(Duration(milliseconds: 100));
                final String t = '$title-$type';
                // ignore: use_build_context_synchronously
                context.pushNamed(
                  'masonry-all-view',
                  extra: {'type': t, 'id': id},
                );
              },
              style: ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text(AppLocalizations.of(context)!.viewAll),
            ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final dynamic data;
  final String type;
  final bool? isForOscars;
  final String? forMovie;

  const _Slide({
    required this.data,
    required this.type,
    this.isForOscars = false,
    this.forMovie = '',
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              } else if (type == 'TVShow') {
                context.pushNamed(TVShowScreen.name, extra: data);
              } else if (type == 'Person') {
                context.pushNamed(
                  PersonScreen.name,
                  extra: data
                );
              }
            },
            child: SizedBox(
              height: 193,
              width: 150,
              child: Stack(
                children: [
                  Hero(
                    tag: data.uniqueID.toString(),
                    child: LoadImage(
                      url:
                          type != "Person" ? data.posterPath : data.profilePath,
                      h: 193,
                      w: 150,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: FavLikeButtonConsumer(data: data, type: type),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 5),

          //*Title
          SizedBox(
            width: 150,
            child: Text(
              type != "Person" ? data.title : data.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle.titleSmall,
            ),
          ),
          !isForOscars!
              ? StarsRatingBarWithInfo(
                rating: type != "Person" ? data.voteAverage : data.popularity,
                voteCount: type != "Person" ? data.voteCount : 0,
                iconSize: 11,
                color: Colors.yellow.shade600,
                type: type != "Person" ? null : "Person",
              )
              : SizedBox(
                width: 150,
                child: Text.rich(
                  TextSpan(
                    text: '${l10n.forLabel}: ',
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: forMovie,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        ],
      ),
    );
  }
}
