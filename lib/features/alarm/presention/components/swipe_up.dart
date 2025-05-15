import 'package:flutter/material.dart';

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
  double _dragDistance = 0;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Define fade animation
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
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
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _dragDistance -= details.delta.dy;
          _dragDistance = _dragDistance.clamp(0, 300); // Increased range
          _controller.stop();
        });
      },
      onVerticalDragEnd: (details) {
        _controller.reverse();
        if (_dragDistance > 200) {
          // Trigger the swipe up action
          widget.onSwipeUp();
        }
        setState(() {
          _dragDistance = 0;
        });
      },
      child: Opacity(
        opacity: (1.0 - (_dragDistance / 80))
            .clamp(0.0, 1.0), // Opacity decreases immediately
        child: Container(
          width: double.infinity,
          height: 200,
          color: Colors.transparent, // Optional: add color for debugging
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      _moveUpAnimation.value - _dragDistance,
                    ), // Move up on drag
                    child: Opacity(
                      opacity: (_fadeAnimation.value + (_dragDistance / 150))
                          .clamp(0.0, 1.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_double_arrow_up,
                            size: 42,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Swipe up to stop alarm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 40,
                child: Container(
                  width: 150,
                  height:
                      _dragDistance.clamp(0, 200), // Increased visual feedback
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
