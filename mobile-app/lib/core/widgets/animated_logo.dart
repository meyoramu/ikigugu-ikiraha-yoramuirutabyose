// core/widgets/animated_logo.dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// An animated logo widget that displays the Ikigugu brand logo using Rive animation.
/// 
/// The logo animates on mouse hover, playing an 'idle' animation when the mouse
/// enters the widget's area and stopping when it exits.
class AnimatedIkiguguLogo extends StatefulWidget {
  /// Creates an animated Ikigugu logo widget.
  /// 
  /// Uses a Rive animation file located at 'assets/animations/lion_logo.riv'.
  const AnimatedIkiguguLogo({super.key});

  @override
  State<AnimatedIkiguguLogo> createState() => _AnimatedIkiguguLogoState();
}

class _AnimatedIkiguguLogoState extends State<AnimatedIkiguguLogo> {
  late RiveAnimationController<RuntimeArtboard> _controller;

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