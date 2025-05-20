import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:cinemania/config/helpers/date_format.dart';

class Reviews extends ConsumerStatefulWidget {
  final String id;
  final String type;
  const Reviews({super.key, required this.id, required this.type});

  @override
  ConsumerState<Reviews> createState() => _ReviewsByMovieState();
}

class _ReviewsByMovieState extends ConsumerState<Reviews> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewsAsync =
        widget.type == 'Movie'
            ? ref.watch(reviewsByMovieProvider(widget.id))
            : ref.watch(reviewsByTVShowProvider(widget.id));

    return reviewsAsync.when(
      loading:
          () => SizedBox(
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
          ),
      error: (err, stack) => SizedBox(),
      data: (reviews) {
        if (reviews.isEmpty) {
          return const SizedBox();
        }

        return Container(
          margin: const EdgeInsets.all(10.0),
          height: 300.0,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  clipBehavior: Clip.hardEdge,
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  LoadImage(
                                    url: review.authorDetails.avatarPath!,
                                    w: 40,
                                    h: 40,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (review.authorDetails.name.isNotEmpty)
                                        SizedBox(
                                          width: 140,
                                          child: Text(
                                            review.authorDetails.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                          ),
                                        ),
                                      SizedBox(
                                        width: 140,
                                        child: Text(
                                          '@${review.authorDetails.username}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (review.authorDetails.rating != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        StarsRatingBarWithInfo(
                                          rating:
                                              review.authorDetails.rating! *
                                              0.5,
                                          iconSize: 13,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      formatDateNew(context, review.createdAt),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 44, 44, 44),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  child: Html(
                                    data: review.content,
                                    style: {
                                      'body': Style(
                                        textAlign: TextAlign.justify,
                                      ),
                                    },
                                    onLinkTap: (url, _, __) {
                                      debugPrint("Opening $url...");
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SmoothPageIndicator(
                controller: _pageController,
                count: reviews.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  expansionFactor: 2.5,
                  dotColor: Colors.grey.shade400,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
