import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedImageWithDebug extends StatefulWidget {
  final String imageUrl;
  const CachedImageWithDebug({super.key, required this.imageUrl});

  @override
  State<CachedImageWithDebug> createState() => _CachedImageWithDebugState();
}

class _CachedImageWithDebugState extends State<CachedImageWithDebug> {
  @override
  void initState() {
    super.initState();
    _logCacheStatus();
  }

  Future<void> _logCacheStatus() async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(
      widget.imageUrl,
    );
    if (fileInfo != null) {
      print('🗂 Imagen cargada desde CACHÉ: ${widget.imageUrl}');
    } else {
      print('🌐 Imagen cargada desde INTERNET: ${widget.imageUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      placeholder:
          (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2,)),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fadeInDuration: Duration(milliseconds: 100),

    );
  }
}
