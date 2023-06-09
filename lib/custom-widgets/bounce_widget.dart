import 'package:flutter/material.dart';

class BounceWidget extends StatefulWidget {
  final String? text;
  final Color color;
  final Widget? icon;
  final Widget? asset;
  final BoxShape shape;
  final VoidCallback onPressed;

  const BounceWidget(
      {super.key,
      this.text,
      required this.color,
      this.icon,
      this.asset,
      required this.shape,
      required this.onPressed});

  @override
  State<BounceWidget> createState() => _BounceWidgetState();
}

class _BounceWidgetState extends State<BounceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Create an animation controller with a duration of 500 milliseconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    // Define a curve for the animation
    /* final CurvedAnimation curve =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut); */

    // Start the animation
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
        _startAnimation();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: 1 - _controller.value * 0.15,
            child: Container(
                width: MediaQuery.of(context).size.width / 2,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                decoration:
                    BoxDecoration(color: widget.color, shape: widget.shape),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.text as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    widget.icon ?? const Text(''),
                    widget.asset ?? const Text(''),
                  ],
                )),
          );
        },
      ),
    );
  }
}
