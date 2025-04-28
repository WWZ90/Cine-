import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/sliver_detail/appbar_netflix.dart';

class TVShowScreen extends ConsumerStatefulWidget {
  static const name = 'tv-show-screen';
  final TVShow tvShow;
  const TVShowScreen({required this.tvShow, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TVShowScreenState();
}

class _TVShowScreenState extends ConsumerState<TVShowScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(tvShowDetailsProvider.notifier)
        .loadTVShow(widget.tvShow.id.toString());

    ref.read(videosMovieProvider(widget.tvShow.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _CustomSliverAppBar(tvShow: widget.tvShow));
  }
}

class _CustomSliverAppBar extends ConsumerStatefulWidget {
  final TVShow tvShow;
  const _CustomSliverAppBar({required this.tvShow});

  @override
  ConsumerState<_CustomSliverAppBar> createState() =>
      _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends ConsumerState<_CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TvShowDetails? tvShowDetails =
        ref.watch(tvShowDetailsProvider)[widget.tvShow.id.toString()];
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: AppBarNetflix(
            minExtend: kToolbarHeight,
            maxExtend: size.height * 0.55,
            size: size,
            data: widget.tvShow,
            type: 'TVShow',
          ),
        ),
        tvShowDetails != null
            ? SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    tvShowDetails.overview.isNotEmpty
                        ? Column(
                          children: [
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                tvShowDetails.overview,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        )
                        : SizedBox(height: 15),
                    VideoTrailer(data: widget.tvShow),
                  ],
                ),
              ),
            )
            : SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            ),
      ],
    );
  }
}
