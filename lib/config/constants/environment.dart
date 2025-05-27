import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String movieDBKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No API Key';
  static String tmdbImageBaseUrlW500 = 'https://image.tmdb.org/t/p/w500';
}
