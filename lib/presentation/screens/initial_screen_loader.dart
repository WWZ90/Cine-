import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      //ref.read(curatedActorsProvider);

      ref.invalidate(movieDetailProvider);
      ref.invalidate(tvShowDetailsProvider);
      ref.invalidate(personDetailProvider);
      ref.invalidate(reviewsByMovieProvider);
      ref.invalidate(reviewsByTVShowProvider);

      ref.invalidate(movieProvider);

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
    final currentShellIndex =
        widget.navigationShell.currentIndex; // Obtener el índice actual

    // Determinar si el BottomNav debe estar visible BASADO EN EL ÍNDICE DE LA BRANCH
    // Y no solo en isFullScreen.
    const List<int> mainBottomNavIndices = [0, 1, 2, 3];
    final bool isMainSectionActive = mainBottomNavIndices.contains(
      currentShellIndex,
    );

    if (isFullScreen) {
      // Si es pantalla completa, siempre oculto, independientemente de la sección
      showNav.value = false;
    } else {
      // Si no es pantalla completa, mostrar solo si estamos en una sección principal
      showNav.value = isMainSectionActive;
    }

    if (isLoading) {
      return Scaffold(
        body: Stack(children: [FullScreenLoader(context: context)]),
      );
    }

    return Scaffold(
      drawer: AppDrawer(navigationShell: widget.navigationShell),
      body: widget.navigationShell,
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: showNav, // showNav ahora refleja el estado correcto
        builder: (_, visibleFromNotifier, __) {
          // 'visibleFromNotifier' ahora es el resultado de la lógica de arriba.
          // La condición original 'mainBottomNavIndices.contains(...)' ya se ha aplicado
          // al establecer showNav.value, por lo que 'visibleFromNotifier' ya tiene eso en cuenta.
          if (!visibleFromNotifier) {
            // Si showNav.value es false, no mostrar.
            return const SizedBox.shrink();
          }

          // Si llegamos aquí, currentShellIndex es uno de [0, 1, 2, 3]
          // y se puede pasar directamente a CustomBottomNavigation.
          return CustomBottomNavigation(
            currentIndex: currentShellIndex,
            onTap:
                (idx, _) =>
                    widget.navigationShell.goBranch(idx, initialLocation: true),
          );
        },
      ),
    );
  }
}
