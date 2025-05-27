import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemania/domain/entities/entities.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class GenresTab extends ConsumerStatefulWidget {
  final String type;
  final List<Genre> genres;
  const GenresTab({required this.type, required this.genres, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GenresTabState();
}

class _GenresTabState extends ConsumerState<GenresTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // El TabController se inicializará en build la primera vez que haya géneros
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Si el TabController no está inicializado y tenemos géneros, lo hacemos.
    // Esto también se encarga de la carga inicial de la primera pestaña.
    if (_tabController == null && widget.genres.isNotEmpty) {
      _initializeTabControllerAndLoadInitial();
    }
  }

  // Nueva función para encapsular la inicialización y la primera carga
  void _initializeTabControllerAndLoadInitial() {
    _tabController = TabController(length: widget.genres.length, vsync: this);
    _tabController!.addListener(() {
      if (!_tabController!.indexIsChanging) {
        // Cuando la animación de cambio de pestaña ha terminado
        _loadInitialDataForCurrentTabIfNeeded();
      }
    });
    // Cargar datos para la pestaña que está inicialmente seleccionada (normalmente la primera)
    // Usamos un microtask para permitir que el build actual termine antes de leer/modificar providers.
    Future.microtask(() => _loadInitialDataForCurrentTabIfNeeded());
  }

  void _loadInitialDataForCurrentTabIfNeeded() {
    if (_tabController == null || widget.genres.isEmpty) return;

    // Asegurarse de que el índice es válido antes de acceder a widget.genres
    if (_tabController!.index < 0 ||
        _tabController!.index >= widget.genres.length)
      return;

    final selectedGenreId = widget.genres[_tabController!.index].id.toString();

    if (widget.type == 'Movie') {
      // Leer el estado actual del provider para este género SIN escuchar cambios.
      // Esto nos da una instantánea del estado actual.
      final moviesState = ref.read(moviesByGenreProvider(selectedGenreId));
      if (moviesState.movies.isEmpty && !moviesState.isLoading) {
        // print("GenresTab: Requesting initial load for Movie genre $selectedGenreId because it's empty.");
        ref
            .read(moviesByGenreProvider(selectedGenreId).notifier)
            .loadNextPage();
      }
    } else {
      // TVShow
      final tvShowsState = ref.read(tvShowsByGenreProvider(selectedGenreId));
      if (tvShowsState.shows.isEmpty && !tvShowsState.isLoading) {
        // print("GenresTab: Requesting initial load for TVShow genre $selectedGenreId because it's empty.");
        ref
            .read(tvShowsByGenreProvider(selectedGenreId).notifier)
            .loadNextPage();
      }
    }
  }

  @override
  void didUpdateWidget(covariant GenresTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si la longitud de la lista de géneros cambia, necesitamos recrear el TabController
    if (widget.genres.length != oldWidget.genres.length) {
      // Quitar el listener del controller antiguo antes de desecharlo
      _tabController?.removeListener(
        _loadInitialDataForCurrentTabIfNeededIfActive,
      ); // Necesitarás un wrapper o adaptar
      _tabController?.dispose();
      _tabController =
          null; // Forzar la reinicialización en el próximo build o didChangeDependencies
      // La reinicialización ocurrirá en el próximo didChangeDependencies o build
    }
  }

  // Adaptación para el listener si se quita en didUpdateWidget
  void _loadInitialDataForCurrentTabIfNeededIfActive() {
    if (_tabController != null && !_tabController!.indexIsChanging) {
      _loadInitialDataForCurrentTabIfNeeded();
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(
      _loadInitialDataForCurrentTabIfNeededIfActive,
    );
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final genres = widget.genres;

    if (genres.isEmpty) {
      return const SizedBox(
        height: 253,
        child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
      );
    }

    // Asegurar que el TabController esté inicializado si es necesario
    // (por ejemplo, si genres se llenó después del primer build)
    if (_tabController == null || _tabController!.length != genres.length) {
      // Si ya existía uno, pero con longitud diferente, lo desechamos
      _tabController?.removeListener(
        _loadInitialDataForCurrentTabIfNeededIfActive,
      );
      _tabController?.dispose();
      _initializeTabControllerAndLoadInitial();
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: _tabController,
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.zero,
            indicatorWeight: 1.0,
            indicatorAnimation: TabIndicatorAnimation.elastic,
            labelColor: Colors.white,
            tabs: genres.map((g) => Tab(text: g.name.toUpperCase())).toList(),
          ),
        ),
        SizedBox(
          height: 253,
          child: TabBarView(
            controller: _tabController,
            children:
                genres.map((g) {
                  return widget.type == 'Movie'
                      ? _GenreTab(genreId: g.id, type: 'Movie')
                      : _GenreTab(genreId: g.id, type: 'TVShow');
                }).toList(),
          ),
        ),
      ],
    );
  }
}

class _GenreTab extends ConsumerWidget {
  final String type;
  final int genreId;

  const _GenreTab({required this.type, required this.genreId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (type == 'Movie') {
      final movies = ref.watch(moviesByGenreProvider(genreId.toString()));
      if (movies.isLoading && movies.movies.isEmpty) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 1));
      }
      return SliderHorizontalListview(
        allData: movies.movies, 
        type: 'Movie',
        isLoadingMore: movies.isLoading, 
        loadNextPage: () {
          ref
              .read(moviesByGenreProvider(genreId.toString()).notifier)
              .loadNextPage();
        },
      );
    } else {
      final tvShows = ref.watch(tvShowsByGenreProvider(genreId.toString()));
      if (tvShows.isLoading && tvShows.shows.isEmpty) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 1));
      }
      return SliderHorizontalListview(
        allData: tvShows.shows,
        type: 'TVShow',
        isLoadingMore: tvShows.isLoading, 
        loadNextPage: () {
          ref
              .read(tvShowsByGenreProvider(genreId.toString()).notifier)
              .loadNextPage();
        },
      );
    }
  }
}
