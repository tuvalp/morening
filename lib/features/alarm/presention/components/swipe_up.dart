import 'package:flutter/material.dart';
import 'package:swipe/swipe.dart';

class SwipeUp extends StatefulWidget {
  final Function() onSwipeUp;
  const SwipeUp({super.key, required this.onSwipeUp});

  @override
  _SwipeUpState createState() => _SwipeUpState();
}

class _SwipeUpState extends State<SwipeUp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _moveUpAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Define fade animation
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Define move-up animation
    _moveUpAnimation = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Loop the animation
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Swipe(
      onSwipeUp: widget.onSwipeUp,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _moveUpAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Icon(
                      Icons.keyboard_double_arrow_up,
                      size: 42,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Swipe up to stop alarm',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
