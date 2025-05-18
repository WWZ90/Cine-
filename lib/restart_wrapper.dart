import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestartWrapper extends StatefulWidget {
  final Widget child;
  const RestartWrapper({super.key, required this.child});

  static void restartApp(BuildContext context) {
    final state = context.findAncestorStateOfType<_RestartWrapperState>();
    state?.restart();
  }

  @override
  State<RestartWrapper> createState() => _RestartWrapperState();
}

class _RestartWrapperState extends State<RestartWrapper> {
  Key key = UniqueKey();

  void restart() {
    setState(() {
      key = UniqueKey(); // 🔁 cambia la key del ProviderScope
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(key: key, child: widget.child);
  }
}
