import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

class ReviewFlags {
  static const _reviewed = 'has_requested_review';
  static const _movie = 'has_visited_movie_detail';
  static const _tvshow = 'has_visited_tvshow_detail';
  static const _person = 'has_visited_person_view';
  static const _favorites = 'has_two_favorites_selected';

  static Future<void> setFlag(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
    await _checkAndRequestReview();
  }

  static Future<void> markTwoFavorites() => setFlag(_favorites);
  static Future<void> markMovieDetail() => setFlag(_movie);
  static Future<void> markTVShowDetail() => setFlag(_tvshow);
  static Future<void> markPersonView() => setFlag(_person);

  static Future<void> _checkAndRequestReview() async {
    final prefs = await SharedPreferences.getInstance();

    final reviewed = prefs.getBool(_reviewed) ?? false;
    if (reviewed) return;

    final movie = prefs.getBool(_movie) ?? false;
    final tv = prefs.getBool(_tvshow) ?? false;
    final person = prefs.getBool(_person) ?? false;
    final favs = prefs.getBool(_favorites) ?? false;

    if (movie && tv && person && favs) {
      final inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        await prefs.setBool(_reviewed, true);
      }
    }
  }
}
