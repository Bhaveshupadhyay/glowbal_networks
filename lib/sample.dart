import 'package:flutter/material.dart';

class BottomToTopAnimation extends StatefulWidget {
  const BottomToTopAnimation({super.key});

  @override
  State<BottomToTopAnimation> createState() => _BottomToTopAnimationState();
}

class _BottomToTopAnimationState extends State<BottomToTopAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _isVisible = true;  // A flag to control widget visibility

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5), // Set animation duration
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.6, 5), // Starting from the bottom (1 on the Y-axis)
      end: Offset(0.6, -5),   // Ending at the top (0 on the Y-axis)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // You can change this to any curve you like
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isVisible = false;  // Hide the widget when animation is complete
        });
      }
    });

    // Start the animation automatically when the widget is first built
  }
  void _triggerAnimation() {
    setState(() {
      _isVisible = true;  // Make the widget visible again when clicked
    });
    _controller.reset(); // Reset the controller to start animation from the beginning
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Only show the widget if _isVisible is true
          Visibility(
            visible: _isVisible,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: 150,
                height: 150,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Slide Me!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Button to trigger the animation
          ElevatedButton(
            onPressed: _triggerAnimation,
            child: Text("Animate Again"),
          ),
        ],
      ),
    );
  }
}