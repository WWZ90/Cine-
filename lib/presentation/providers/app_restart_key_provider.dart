import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalRestartKey = ValueNotifier<Key>(UniqueKey());

final appRestartKeyProvider = Provider<ValueNotifier<Key>>((ref) {
  return globalRestartKey;
});
