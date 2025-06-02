import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/config/helpers/ask_for_review_if_needed.dart';
import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final Movie movie;
  const MovieScreen({super.key, required this.movie});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    final id = widget.movie.id.toString();
    ref.read(movieDetailProvider.notifier).loadMovie(id);
    ref.read(movieCreditsProvider.notifier).loadCredits(id);

    ref.read(videosMovieProvider(id));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(similarMoviesProvider(id).notifier).loadNextPage();
    });
    ref.read(reviewsByMovieProvider(id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _CustomSliverAppBar(movie: widget.movie));
  }
}

class _CustomSliverAppBar extends ConsumerStatefulWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

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
      ReviewFlags.markMovieDetail();
      _viewMarked = true;
      _reviewTimer?.cancel();
      _scrollController.removeListener(_onScroll);
    } else {
      if (_hasScrolledToEnd)
        print("Screen: Scrolled to end, waiting for time.");
      if (_hasTimeElapsed)
        print("Screen: Time elapsed, waiting for scroll.");
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
    final MovieDetail? movieDetails =
        ref.watch(movieDetailProvider)[widget.movie.id.toString()];

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPersistentHeader(
          delegate: AppBarNetflix(
            minExtend: kToolbarHeight,
            maxExtend: size.height * 0.55, //0.35
            size: size,
            data: widget.movie,
            type: 'Movie',
          ),
        ),
        movieDetails != null
            ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [MovieDetailCard(movieDetails: movieDetails)],
                ),
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
