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

    ref
        .read(videosTVShowProvider.notifier)
        .loadVideosTVShow(widget.tvShow.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final TvShowDetails? tvShowDetails =
        ref.watch(tvShowDetailsProvider)[widget.tvShow.id.toString()];
    final List<Video> videos = ref.watch(videosTVShowProvider);
    return Scaffold(
      body:
          tvShowDetails != null
              ? _CustomSliverAppBar(
                tvShow: widget.tvShow,
                tvShowDetails: tvShowDetails,
                videos: videos,
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final TVShow tvShow;
  final TvShowDetails tvShowDetails;
  final List<Video> videos;
  const _CustomSliverAppBar({
    required this.tvShow,
    required this.tvShowDetails,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: AppBarNetflix(
            minExtend: kToolbarHeight,
            maxExtend: size.height * 0.55,
            size: size,
            data: tvShow,
            type: 'TVShow',
            videos: videos,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [SizedBox(height: 10), Text(tvShowDetails.overview)],
            ),
          ),
        ),
      ],
    );
  }
}
