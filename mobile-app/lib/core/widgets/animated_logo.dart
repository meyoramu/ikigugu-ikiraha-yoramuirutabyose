// core/widgets/animated_logo.dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedIkiguguLogo extends StatefulWidget {
  const AnimatedIkiguguLogo({super.key});

  @override
  State<AnimatedIkiguguLogo> createState() => _AnimatedIkiguguLogoState();
}

class _AnimatedIkiguguLogoState extends State<AnimatedIkiguguLogo> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('idle');
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.isActive = true,
      onExit: (_) => _controller.isActive = false,
      child: RiveAnimation.asset(
        'assets/animations/lion_logo.riv',
        controllers: [_controller],
        fit: BoxFit.contain,
      ),
    );
  }
}