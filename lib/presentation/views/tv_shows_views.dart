import 'package:flutter/material.dart';

class TVShowsViews extends StatelessWidget {
  static const name = 'tv-shows-view';
  const TVShowsViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TV Shows View')),
      body: Center(child: Text('TV Shows')),
    );
  }
}
