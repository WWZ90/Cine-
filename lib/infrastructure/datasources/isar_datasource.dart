import 'dart:io';
import 'dart:ui';

import 'package:cinemania/config/global_app_state.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cinemania/domain/entities/movie.dart';
import 'package:cinemania/domain/entities/person.dart';
import 'package:cinemania/domain/entities/tv_show.dart';
import 'package:cinemania/infrastructure/models/settings/app_settings.dart';
import 'package:cinemania/domain/datasources/local_storage_datasource.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationCacheDirectory();
    final path = dir.path;

    try {
      return await Isar.open([
        MovieSchema,
        TVShowSchema,
        PersonSchema,
        AppSettingsSchema,
      ], directory: path);
    } on IsarError catch (e) {
      // Si es error de versión, borra los archivos .isar
      if (e.message.contains('version of the file')) {
        final dbDir = Directory(path);
        for (final file in dbDir.listSync()) {
          if (file.path.endsWith('.isar') || file.path.endsWith('.lock')) {
            try {
              file.deleteSync();
            } catch (_) {}
          }
        }
        // Reintenta sobre una carpeta limpia
        return await Isar.open([
          MovieSchema,
          TVShowSchema,
          PersonSchema,
          AppSettingsSchema,
        ], directory: path);
      }
      rethrow;
    }
  }

  @override
  Future<bool> isFavorite(int id, String type) async {
    final isar = await db;

    if (type == 'Movie') {
      final isFavorite = await isar.movies.filter().idEqualTo(id).findFirst();
      return isFavorite != null;
    } else if (type == 'TVShow') {
      final isFavorite = await isar.tVShows.filter().idEqualTo(id).findFirst();
      return isFavorite != null;
    } else {
      final isFavorite = await isar.persons.filter().idEqualTo(id).findFirst();
      return isFavorite != null;
    }
  }

  @override
  Future<void> toggleFavorite(dynamic data, String type) async {
    final isar = await db;

    dynamic favorite;

    if (type == 'Movie') {
      favorite = await isar.movies.filter().idEqualTo(data.id).findFirst();
      if (favorite != null) {
        isar.writeTxnSync(() => isar.movies.deleteSync(favorite.isarMovieId!));
        return;
      }
      isar.writeTxnSync(() => isar.movies.putSync(data));
    } else if (type == 'TVShow') {
      favorite = await isar.tVShows.filter().idEqualTo(data.id).findFirst();
      if (favorite != null) {
        isar.writeTxnSync(
          () => isar.tVShows.deleteSync(favorite.isarTVShowId!),
        );
        return;
      }
      isar.writeTxnSync(() => isar.tVShows.putSync(data));
    } else {
      favorite = await isar.persons.filter().idEqualTo(data.id).findFirst();
      if (favorite != null) {
        isar.writeTxnSync(
          () => isar.persons.deleteSync(favorite.isarPersonId!),
        );
        return;
      }
      isar.writeTxnSync(() => isar.persons.putSync(data));
    }
  }

  @override
  Future<List<dynamic>> loadFavorites({int limit = 10, int offset = 0}) async {
    final isar = await db;

    var movies =
        await isar.movies.where().offset(offset).limit(limit).findAll();

    var tvShows =
        await isar.tVShows.where().offset(offset).limit(limit).findAll();

    var persons =
        await isar.persons.where().offset(offset).limit(limit).findAll();

    // Combinamos ambas listas
    return [...movies, ...tvShows, ...persons];
  }

  Future<Locale> getAppLocale() async {
    final isar = await db;

    final settings = await isar.appSettings.where().findFirst();
    final code = settings?.languageCode ?? 'en';

    return Locale(code, '');
  }

  Future<void> setAppLocale(Locale locale) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.appSettings.clear();
      await isar.appSettings.put(
        AppSettings()..languageCode = locale.languageCode,
      );
    });

    GlobalAppState.currentLocale = locale;
  }
}
