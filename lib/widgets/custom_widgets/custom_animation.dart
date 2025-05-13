import 'dart:async';

import 'package:flutter/material.dart';

enum AnimDirection { leftToRight, rightToLeft, topToBottom, bottomToTop }

class Animator extends StatefulWidget {
  final Widget child;
  final Duration time;
  final AnimDirection animationDirection;
  final Duration duration;
  const Animator({
    Key? key,
    required this.child,
    required this.time,
    required this.animationDirection,
    required this.duration,
  }) : super(key: key);
  @override
  State<Animator> createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  late AnimationController animationController;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    timer = Timer(widget.time, animationController.forward);
  }

  @override
  void dispose() {
    timer.cancel();
    animationController.dispose();
    super.dispose();
  }

  double distance = 30;
  Offset getOffset() {
    switch (widget.animationDirection) {
      case AnimDirection.leftToRight:
        return Offset(-(1 - animation.value) * distance, 0.0);

      case AnimDirection.rightToLeft:
        return Offset((1 - animation.value) * distance, 0.0);

      case AnimDirection.topToBottom:
        return Offset(0.0, -(1 - animation.value) * distance);

      case AnimDirection.bottomToTop:
        return Offset(0.0, (1 - animation.value) * distance);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: getOffset(),
            child: child,
          ),
        );
      },
    );
  }
}

Timer? timer;
Duration duration = const Duration();
Duration getDelay(int delay) {
  if (timer == null || !timer!.isActive) {
    timer = Timer(const Duration(microseconds: 120), () {
      duration = const Duration();
    });
  }
  duration += Duration(milliseconds: 100 + delay);
  return duration;
}

class FadeSlideTransition extends StatelessWidget {
  final Widget child;
  final int delay;
  final AnimDirection animationDirection;
  final Duration duration;

  const FadeSlideTransition({
    Key? key,
    required this.child,
    this.delay = 0,
    required this.animationDirection,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Animator(
      time: getDelay(delay),
      duration: duration,
      animationDirection: animationDirection,
      child: child,
    );
  }
}
