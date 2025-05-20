// features/home/presentation/widgets/puff_3d_viewer.dart
import 'package:flutter/material.dart';
import 'package:flutter_rive/flutter_rive.dart';

class Puff3DViewer extends StatefulWidget {
  final RiveAnimationController controller;

  const Puff3DViewer({super.key, required this.controller});

  @override
  State<Puff3DViewer> createState() => _Puff3DViewerState();
}

class _Puff3DViewerState extends State<Puff3DViewer> {
  late RiveAnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = SimpleAnimation('scale');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (_) => widget.controller.isActive = true,
      onScaleUpdate: (details) {
        // Handle scaling and rotation
      },
      child: RiveAnimation.asset(
        'assets/animations/puff_3d.riv',
        controllers: [widget.controller, _scaleController],
        fit: BoxFit.contain,
      ),
    );
  }
}