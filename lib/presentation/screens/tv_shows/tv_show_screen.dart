import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/config/helpers/ask_for_review_if_needed.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class TVShowScreen extends ConsumerStatefulWidget {
  static const name = 'tv-show-screen';
  final TVShow tvShow;
  const TVShowScreen({required this.tvShow, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TVShowScreenState();
}

class _TVShowScreenState extends ConsumerState<TVShowScreen> {
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
  Timer? _reviewTimer;
  final ScrollController _scrollController = ScrollController();
  bool _viewMarked = false;
  bool _hasScrolledToEnd = false;
  bool _hasTimeElapsed = false;

  @override
  void initState() {
    super.initState();
    final id = widget.tvShow.id.toString();
    ref.read(tvShowDetailsProvider.notifier).loadTVShow(id);

    ref.read(videosTVShowProvider(id));

    ref.read(reviewsByTVShowProvider(id));
    ref.read(tvShowCreditsProvider.notifier).loadCredits(id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(similarTVShowsProvider(id).notifier).loadNextPage();
    });

    _scrollController.addListener(_onScroll);

    _reviewTimer = Timer(const Duration(seconds: 15), () {
      if (mounted) {
        print("Screen: 15 seconds timer elapsed.");
        _hasTimeElapsed = true;
        _checkConditionsAndMarkView();
      }
    });
  }

  void _onScroll() {
    if (!mounted || _viewMarked) return;

    final atBottomThreshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.offset >= atBottomThreshold &&
        _scrollController.position.maxScrollExtent > 0) {
      if (!_hasScrolledToEnd) {
        print("Screen: Scrolled near to end.");
        _hasScrolledToEnd = true;
        _checkConditionsAndMarkView();
      }
    }
  }

  void _checkConditionsAndMarkView() {
    if (!mounted || _viewMarked) return;
    if (_hasScrolledToEnd && _hasTimeElapsed) {
      print(
        "Screen: Both conditions (scroll to end AND time elapsed) met. Marking view.",
      );
      ReviewFlags.markTVShowDetail();
      _viewMarked = true;
      _reviewTimer?.cancel();
      _scrollController.removeListener(_onScroll);
    } else {
      if (_hasScrolledToEnd)
        print("Screen: Scrolled to end, waiting for time.");
      if (_hasTimeElapsed) print("Screen: Time elapsed, waiting for scroll.");
    }
  }

  @override
  void dispose() {
    _reviewTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TvShowDetails? tvShowDetails =
        ref.watch(tvShowDetailsProvider)[widget.tvShow.id.toString()];
    return CustomScrollView(
      controller: _scrollController,
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
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: TvShowDetailCard(tvShowDetails: tvShowDetails),
              ),
            )
            : SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
              ),
            ),
      ],
    );
  }
}
