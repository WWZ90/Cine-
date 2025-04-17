import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: 'movie-screen',
          name: MovieScreen.name,
          builder: (context, state) {
            //final movieId = state.pathParameters['movieId'] ?? 'no-id';
            //return MovieScreen(movieId: movieId);
            final movie = state.extra as Movie;
            return MovieScreen(movie: movie);
          },
        ),
        GoRoute(
          path: 'video-screen',
          name: VideosPage.name,
          builder: (context, state) => VideosPage(),
        ),
      ],
    ),
  ],
);
