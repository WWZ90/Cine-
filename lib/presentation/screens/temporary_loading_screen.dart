import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TemporaryLoadingScreen extends StatelessWidget {
  const TemporaryLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 17, 18, 24),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeIn(
              child: SizedBox(
                width: 80,
                height: 230,
                child: Center(
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 56,
                        child: Image.asset(
                          'assets/images/1.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                      Positioned(
                        bottom: 77,
                        right: 3,
                        child: Image.asset(
                          'assets/images/+.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
