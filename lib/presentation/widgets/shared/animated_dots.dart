import 'package:flutter/material.dart';

class AnimatedDots extends StatefulWidget {
  const AnimatedDots({
    super.key,
    this.color = Colors.white,
    this.fontSize = 20,
  });

  final Color color;
  final double fontSize;

  @override
  State<AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    _dotCount = StepTween(
      begin: 1,
      end: 4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotCount,
      builder: (context, child) {
        final dots = '.' * _dotCount.value;
        return Text(
          dots,
          style: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}
