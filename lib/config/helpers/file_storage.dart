// lib/utils/local_image_file_manager.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class LocalImageFileManager {
  static late Directory _postersDir;

  /// Call once in main() before using
  static Future<void> init() async {
    final baseDir = await getApplicationDocumentsDirectory();
    _postersDir = Directory(p.join(baseDir.path, 'posters'));

    if (!await _postersDir.exists()) {
      await _postersDir.create(recursive: true);
    }
  }

  static File fileFromPostersDir(String filename) {
    final path = p.join(_postersDir.path, filename);
    return File(path);
  }

  static File fileFromUrl(String url) {
    final filename = p.basename(Uri.parse(url).path);
    return fileFromPostersDir(filename);
  }
}
