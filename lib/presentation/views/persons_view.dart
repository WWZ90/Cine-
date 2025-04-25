import 'package:flutter/material.dart';

class PersonsViews extends StatelessWidget {
  static const name = 'persons-view';
  const PersonsViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Persons View')),
      body: Center(child: Text('Persons')),
    );
  }
}
