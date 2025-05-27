import 'package:flutter/material.dart';

class PremiumView extends StatelessWidget {
  static const name = 'premium-view';
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('assets/images/premium.jpg', fit: BoxFit.cover));
  }
}
