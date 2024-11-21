import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedBell extends StatefulWidget {
  const AnimatedBell({super.key});

  @override
  _AnimatedBellState createState() => _AnimatedBellState();
}

class _AnimatedBellState extends State<AnimatedBell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tiltAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    // Animation for tilting side to side
    _tiltAnimation = Tween<double>(
      begin: -pi / 8,
      end: pi / 8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animation for scaling up and down
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateZ(_tiltAnimation.value)
              ..scale(_scaleAnimation.value),
            child: child,
          );
        },
        child: const Icon(
          Icons.notifications,
          size: 160.0,
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}
