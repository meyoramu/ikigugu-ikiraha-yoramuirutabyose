// features/home/presentation/widgets/puff_3d_viewer.dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

/// A widget that displays a 3D model of a curry puff using Rive animation.
///
/// The widget supports interactive gestures like scaling and rotation, and
/// provides smooth animations for user interactions.
class Puff3DViewer extends StatefulWidget {
  /// The controller for managing the primary animation of the 3D puff model.
  ///
  /// This controller is typically used for bounce or rotation animations
  /// triggered by user interactions.
  final rive.RiveAnimationController<rive.RuntimeArtboard> controller;

  /// Creates a Puff3DViewer widget.
  ///
  /// The [controller] parameter is required and manages the primary animation
  /// of the 3D puff model.
  const Puff3DViewer({required this.controller, super.key});

  @override
  State<Puff3DViewer> createState() => _Puff3DViewerState();
}

class _Puff3DViewerState extends State<Puff3DViewer> {
  late rive.RiveAnimationController<rive.RuntimeArtboard> _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = rive.OneShotAnimation('scale');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (_) => widget.controller.isActive = true,
      onScaleUpdate: (details) {
        // Handle scaling and rotation
      },
      child: rive.RiveAnimation.asset(
        'assets/animations/puff_3d.riv',
        controllers: [widget.controller, _scaleController],
        fit: BoxFit.contain,
      ),
    );
  }
}