import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';


class InitialScreenLoader extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const InitialScreenLoader({super.key, required this.navigationShell});

  @override
  ConsumerState<InitialScreenLoader> createState() =>
      InitialScreenLoaderState();
}

class InitialScreenLoaderState extends ConsumerState<InitialScreenLoader> {
  final ValueNotifier<bool> showNav = ValueNotifier(true);
  bool initialCheckDone = false;
  bool shouldShowLoader = true;
  bool showRestartMessage = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      // Llamadas de carga inicial
      ref.read(nowPlayingMoviesProvider.notifier).reset();
      ref.read(upcomingMoviesProvider.notifier).reset();
      ref.read(popularMoviesProvider.notifier).reset();
      ref.read(topRatedMoviesProvider.notifier).reset();

      ref.read(genresMovieProvider.notifier).loadGenres();
      ref.read(genresTVShowProvider.notifier).loadGenres();

      ref.read(airingTodayTVShowsProvider.notifier).reset();
      ref.read(onTheAirTVShowsProvider.notifier).reset();
      ref.read(popularTVShowsProvider.notifier).reset();
      ref.read(topRatedTVShowsProvider.notifier).reset();

      ref.read(personPopularProvider.notifier).loadNextPage();
      ref.read(curatedActorsProvider);

      // Oculta el mensaje transitorio después de 1.5 segundos
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showRestartMessage = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFullScreen = ref.watch(isFullscreenProvider);
    final isLoading = ref.watch(initialLoadingProvider);

    if (!initialCheckDone && !isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            shouldShowLoader = false;
            initialCheckDone = true;
          });
        }
      });
    }

    if (isFullScreen) {
      showNav.value = false;
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) showNav.value = true;
      });
    }

    if (!initialCheckDone || shouldShowLoader) {
      return Scaffold(
        body: Stack(
          children: [
            FullScreenLoader(context: context),

            // Mensaje sobrepuesto (solo por breve momento)
            // if (showRestartMessage)
            //   Positioned.fill(
            //     bottom: 40,
            //     child: AnimatedOpacity(
            //       opacity: showRestartMessage ? 1.0 : 0.0,
            //       duration: const Duration(milliseconds: 600),
            //       child: Container(
            //         color: Colors.black.withOpacity(0.5),
            //         child: Center(
            //           child: Text(
            //             AppLocalizations.of(context)!.restarting,
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 20,
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      );
    }

    return Scaffold(
      drawer: AppDrawer(navigationShell: widget.navigationShell),
      body: widget.navigationShell,
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: showNav,
        builder: (_, visible, __) {
          return visible
              ? CustomBottomNavigation(
                currentIndex: widget.navigationShell.currentIndex,
                onTap:
                    (idx, _) => widget.navigationShell.goBranch(
                      idx,
                      initialLocation: true,
                    ),
              )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
