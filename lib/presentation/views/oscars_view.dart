import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:cinemania/infrastructure/models/moviedb/oscars/oscars_model.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';

class OscarsView extends ConsumerWidget {
  static const name = 'oscars-view';
  final String? selectedCategory;
  final StatefulNavigationShell navigationShell;

  const OscarsView({
    required this.navigationShell,
    this.selectedCategory,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final paginatedState = ref.watch(oscarsCeremoniesProvider);

    final ceremoniesToDisplay =
        paginatedState.ceremonies
            .where(
              (ceremony) => ceremony.categories.any(
                (cat) =>
                    selectedCategory == null ||
                    cat.category == selectedCategory,
              ),
            )
            .toList();

    String appBarTitle = l10n.oscars; // Título base
    final String? currentSelectedCategory =
        selectedCategory; // Para evitar múltiples accesos

    if (currentSelectedCategory != null) {
      // Mapeo de claves de categoría (como están en el JSON) a etiquetas localizadas
      final Map<String, String> categoryDisplayNames = {
        'Best Picture': l10n.bestPictureLabel,
        'Animated Feature Film': l10n.animatedFeatureFilmLabel,
        'Best Visual Effects': l10n.visualEffectsLabel,
        'Best Director':
            l10n.directingLabel, // Asegúrate que exista 'directingLabel' en tus .arb
        // Añade otros mapeos aquí si es necesario
      };
      // Usar el nombre localizado si está en el mapa, sino usar el selectedCategory directamente
      appBarTitle =
          categoryDisplayNames[currentSelectedCategory] ??
          currentSelectedCategory;
    }
    return Scaffold(
      drawer: AppDrawer(navigationShell: navigationShell),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true, // o false si quieres que desaparezca totalmente
            snap: true,
            backgroundColor: const Color.fromARGB(135, 17, 17, 17),
            automaticallyImplyLeading: false,
            expandedHeight: 210,
            title: Row(
              children: [
                Builder(
                  builder:
                      (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                ),
                Expanded(
                  child: Text(
                    appBarTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final double deltaExtent =
                    constraints.maxHeight - kToolbarHeight;
                final double opacity = (deltaExtent / (230 - kToolbarHeight))
                    .clamp(0.0, 1.0);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: opacity,
                      child: Image.asset(
                        'assets/images/oscars.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(color: const Color.fromARGB(77, 0, 0, 0)),
                  ],
                );
              },
            ),
          ),

          if (paginatedState.ceremonies.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeIn(
                      duration: Duration(milliseconds: 400),
                      child: CircularProgressIndicator(strokeWidth: 1),
                    ),
                    SizedBox(height: 16),
                    FadeIn(
                      duration: Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 100),
                      child: Text(
                        l10n.loadingCeremonies,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (ceremoniesToDisplay.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final ceremony = ceremoniesToDisplay[index];
                return _CeremonyWithVisibility(
                  ceremony: ceremony,
                  selectedCategory: selectedCategory,
                );
              }, childCount: ceremoniesToDisplay.length),
            ),
        ],
      ),
    );
  }
}

class _CeremonyWithVisibility extends StatefulWidget {
  final Ceremony ceremony;
  final String? selectedCategory;

  const _CeremonyWithVisibility({
    required this.ceremony,
    required this.selectedCategory,
  });

  @override
  State<_CeremonyWithVisibility> createState() =>
      _CeremonyWithVisibilityState();
}

class _CeremonyWithVisibilityState extends State<_CeremonyWithVisibility>
    with AutomaticKeepAliveClientMixin {
  bool _visible = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final filteredCategories =
        widget.ceremony.categories
            .where(
              (cat) =>
                  widget.selectedCategory == null ||
                  cat.category == widget.selectedCategory,
            )
            .toList();

    if (filteredCategories.isEmpty) return const SizedBox.shrink();

    final filteredCeremony = Ceremony(
      ceremonyYear: widget.ceremony.ceremonyYear,
      ceremonyNumber: widget.ceremony.ceremonyNumber,
      ceremonyDate: widget.ceremony.ceremonyDate,
      categories: filteredCategories,
    );

    final categoryKey =
        '${filteredCeremony.ceremonyNumber}-${widget.selectedCategory ?? 'all'}';

    return VisibilityDetector(
      key: Key('ceremony-visibility-${filteredCeremony.ceremonyNumber}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Column(
        key: ValueKey('ceremony-wrapper-$categoryKey'),
        children: [
          CeremonyListItem(
            key: ValueKey(categoryKey),
            ceremony: filteredCeremony,
            shouldLoadNonWinners: _visible,
          ),
          const Divider(
            height: 40,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}


/*
import 'package:cinemania/infrastructure/models/moviedb/oscars/oscars_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemania/presentation/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cinemania/presentation/widgets/widgets.dart';

class OscarsView extends ConsumerStatefulWidget {
  static const name = 'oscars-view';
  final String? selectedCategory;
  const OscarsView({this.selectedCategory, super.key});

  @override
  ConsumerState<OscarsView> createState() => _OscarsViewState();
}

class _OscarsViewState extends ConsumerState<OscarsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      ref.read(oscarsCeremoniesProvider.notifier).loadMoreCeremonies();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final paginatedState = ref.watch(oscarsCeremoniesProvider);

    // Determinar la categoría a mostrar consistentemente
    final String categoryToDisplay =
        widget.selectedCategory ?? "Best Picture"; // Default a "Best Picture"

    List<Ceremony> ceremoniesToDisplay = [];
    for (var ceremonyFull in paginatedState.ceremonies) {
      // Iterar sobre las ceremonias del provider
      final List<OscarCategory> relevantCategories;
      if (widget.selectedCategory != null) {
        // Filtrar para la categoría seleccionada
        relevantCategories =
            ceremonyFull.categories
                .where((cat) => cat.category == widget.selectedCategory)
                .toList();
      } else {
        // Default: Mostrar solo "Best Picture" si no hay selección (o la primera si "Best Picture" no existe)
        relevantCategories =
            ceremonyFull.categories
                .where((cat) => cat.category == "Best Picture")
                .toList();
        // Opcional: si "Best Picture" podría no existir y quieres la primera categoría disponible:
        // if (relevantCategories.isEmpty && ceremonyFull.categories.isNotEmpty) {
        //   relevantCategories = [ceremonyFull.categories.first];
        // }
      }

      if (relevantCategories.isNotEmpty) {
        // Crear un nuevo objeto Ceremony que SOLO contenga las categorías relevantes
        ceremoniesToDisplay.add(
          Ceremony(
            ceremonyYear: ceremonyFull.ceremonyYear,
            ceremonyNumber: ceremonyFull.ceremonyNumber,
            ceremonyDate: ceremonyFull.ceremonyDate,
            categories: relevantCategories, // Solo las categorías filtradas
          ),
        );
      }
    }

    String appBarTitle = l10n.oscars;
    if (categoryToDisplay == 'Best Picture') {
      appBarTitle = '${l10n.oscars} - ${l10n.bestPictureLabel}';
    } else if (categoryToDisplay == 'Animated Feature Film') {
      appBarTitle = '${l10n.oscars} - ${l10n.animatedFeatureFilmLabel}';
    } else if (categoryToDisplay == 'Best Visual Effects') {
      appBarTitle = '${l10n.oscars} - ${l10n.visualEffectsLabel}';
    } else if (widget.selectedCategory != null) {
      appBarTitle = '${l10n.oscars} - ${widget.selectedCategory}';
    }

    if (ceremoniesToDisplay.isEmpty &&
        paginatedState.isLoadingMore &&
        paginatedState.ceremonies.isEmpty) {
      // ...
    } else if (ceremoniesToDisplay.isEmpty &&
        !paginatedState.isLoadingMore &&
        !paginatedState.hasMore) {
      // ...
    }

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar con imagen de fondo
          
SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appBarTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            expandedHeight: 200,
            pinned: true,
            elevation: 2.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              centerTitle: true,
              title: Text(
                appBarTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black.withOpacity(0.7),
                      offset: const Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/oscars.jpg', fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.3)),
                ],
              ),
            ),
          ),

          // Loader inicial (si aún no hay datos)
          if (ceremoniesToDisplay.isEmpty &&
              paginatedState.isLoadingMore &&
              paginatedState.ceremonies.isEmpty)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(strokeWidth: 1)),
            )
          // No hay más datos
          else if (ceremoniesToDisplay.isEmpty &&
              !paginatedState.hasMore &&
              !paginatedState.isLoadingMore)
            SliverFillRemaining(
              child: Center(child: Text(l10n.noDataAvailable)),
            )
          // Lista de ceremonias
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == ceremoniesToDisplay.length) {
                    return paginatedState.isLoadingMore
                        ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 1),
                          ),
                        )
                        : const SizedBox(height: 20);
                  }

                  final ceremony = ceremoniesToDisplay[index];
                  return Column(
                    key: ValueKey(
                      'ceremony-wrapper-${ceremony.ceremonyNumber}-${widget.selectedCategory ?? ceremony.categories.first.category}',
                    ),
                    children: [
                      CeremonyListItem(
                        key: ValueKey(
                          '${ceremony.ceremonyNumber}-${widget.selectedCategory ?? ceremony.categories.first.category}',
                        ),
                        ceremony: ceremony,
                      ),
                      if (index < ceremoniesToDisplay.length - 1 ||
                          (index == ceremoniesToDisplay.length - 1 &&
                              paginatedState.hasMore))
                        const Divider(
                          height: 40,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Colors.grey,
                        ),
                    ],
                  );
                },
                childCount:
                    ceremoniesToDisplay.length +
                    (paginatedState.hasMore ? 1 : 0),
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
              ),
            ),
        ],
      ),
    );
  }
}
*/