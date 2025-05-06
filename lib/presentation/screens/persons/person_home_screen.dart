import 'package:cinemania/presentation/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonHomeScreen extends ConsumerStatefulWidget {
  static const name = 'home-screen-person';
  const PersonHomeScreen({super.key});

  @override
  ConsumerState<PersonHomeScreen> createState() => _PersonHomeScreenState();
}

class _PersonHomeScreenState extends ConsumerState<PersonHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PersonsViews());
  }
}
