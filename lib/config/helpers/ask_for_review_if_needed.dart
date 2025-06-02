import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

class ReviewFlags {
  // Claves para SharedPreferences
  static const _stopAutomaticRequestsKey = 'stop_automatic_review_requests';
  static const _reviewRequestAttemptsKey = 'review_request_attempts';
  static const _lastReviewAttemptTimestampKey = 'last_review_attempt_timestamp';

  // Flags de condiciones de la app
  static const _movieFlag = 'has_visited_movie_detail';
  static const _tvshowFlag = 'has_visited_tvshow_detail';
  static const _personFlag = 'has_visited_person_view';
  static const _favoritesFlag = 'has_two_favorites_selected';

  // Configuraciones
  static const int _maxReviewRequestAttempts = 3;
  static const Duration _minIntervalBetweenAttempts = Duration(hours: 24);

  // --- Método privado para marcar una flag de condición ---
  // Este método ahora solo se encarga de poner la flag en true si no lo estaba.
  static Future<void> _ensureConditionFlagSet(String key) async {
    final prefs = await SharedPreferences.getInstance();
    // Solo escribe en SharedPreferences si la flag no estaba ya en true,
    // para minimizar escrituras innecesarias.
    if (!(prefs.getBool(key) ?? false)) {
      await prefs.setBool(key, true);
      print("ReviewFlag condition newly set: $key");
    }
  }

  // --- Métodos Públicos para Marcar Flags de Condiciones Y Comprobar Revisión ---
  static Future<void> markTwoFavorites() async {
    await _ensureConditionFlagSet(_favoritesFlag);
    await _checkAndRequestReview(); // Siempre llama a check después de marcar
  }

  static Future<void> markMovieDetail() async {
    await _ensureConditionFlagSet(_movieFlag);
    await _checkAndRequestReview();
  }

  static Future<void> markTVShowDetail() async {
    await _ensureConditionFlagSet(_tvshowFlag);
    await _checkAndRequestReview();
  }

  static Future<void> markPersonView() async {
    await _ensureConditionFlagSet(_personFlag);
    await _checkAndRequestReview();
  }

  static Future<void> _checkAndRequestReview() async {
    final prefs = await SharedPreferences.getInstance();

    final bool shouldStopRequests =
        prefs.getBool(_stopAutomaticRequestsKey) ?? false;
    if (shouldStopRequests) {
      return;
    }

    final bool movieConditionMet = prefs.getBool(_movieFlag) ?? false;
    final bool tvShowConditionMet = prefs.getBool(_tvshowFlag) ?? false;
    final bool personConditionMet = prefs.getBool(_personFlag) ?? false;
    final bool favoritesConditionMet = prefs.getBool(_favoritesFlag) ?? false;

    if (!(movieConditionMet &&
        tvShowConditionMet &&
        personConditionMet &&
        favoritesConditionMet)) {
      return; 
    }
    print("InAppReview: All app conditions for review are met.");

    final int lastAttemptMillis =
        prefs.getInt(_lastReviewAttemptTimestampKey) ?? 0;
    final int nowMillis = DateTime.now().millisecondsSinceEpoch;

    if (lastAttemptMillis != 0 &&
        (nowMillis - lastAttemptMillis <
            _minIntervalBetweenAttempts.inMilliseconds)) {
      print(
        "InAppReview: Attempt too soon. Waiting for the 24-hour interval to pass. Last attempt: ${DateTime.fromMillisecondsSinceEpoch(lastAttemptMillis)}",
      );
      return;
    }
    print(
      "InAppReview: Sufficient time has passed since last attempt (or this is the eligible first attempt).",
    );

    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      print("InAppReview: API is available.");
      int attempts = prefs.getInt(_reviewRequestAttemptsKey) ?? 0;

      if (attempts < _maxReviewRequestAttempts) {
        print(
          "InAppReview: Attempting review. Attempt #${attempts + 1} of $_maxReviewRequestAttempts",
        );

        await inAppReview.requestReview();

        await prefs.setInt(
          _lastReviewAttemptTimestampKey,
          DateTime.now().millisecondsSinceEpoch,
        );

        attempts++;
        await prefs.setInt(_reviewRequestAttemptsKey, attempts);
        print("InAppReview: Attempt recorded. Total attempts: $attempts.");

        if (attempts >= _maxReviewRequestAttempts) {
          print(
            "InAppReview: Max attempts reached. Stopping automatic requests for this logic.",
          );
          await prefs.setBool(_stopAutomaticRequestsKey, true);
        }
      } else {
        print(
          "InAppReview: Max attempts already reached previously. Not requesting again.",
        );
        if (!shouldStopRequests) {
          await prefs.setBool(_stopAutomaticRequestsKey, true);
        }
      }
    } else {
      print(
        "InAppReview: API not available. Stopping automatic requests for this logic.",
      );
      await prefs.setBool(_stopAutomaticRequestsKey, true);
    }
  }

  static Future<void> resetReviewFlagsForTesting() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_stopAutomaticRequestsKey);
    await prefs.remove(_reviewRequestAttemptsKey);
    await prefs.remove(_lastReviewAttemptTimestampKey);
    await prefs.remove(_movieFlag);
    await prefs.remove(_tvshowFlag);
    await prefs.remove(_personFlag);
    await prefs.remove(_favoritesFlag);
    print("Review flags have been reset for testing.");
  }
}
