// features/ar_preview/presentation/screens/ar_puff_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_arkit/flutter_arkit.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARPuffScreen extends StatefulWidget {
  final int puffId;

  const ARPuffScreen({super.key, required this.puffId});

  @override
  State<ARPuffScreen> createState() => _ARPuffScreenState();
}

class _ARPuffScreenState extends State<ARPuffScreen> {
  late ARKitController arkitController;
  bool isPuffPlaced = false;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Puff Preview'),
      ),
      body: ARKitSceneView(
        onARKitViewCreated: onARKitViewCreated,
        enableTapRecognizer: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isPuffPlaced) {
            _addPuffToScene();
            isPuffPlaced = true;
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController.onAddNodeForAnchor = _handleAddAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    // Handle anchor addition
  }

  void _addPuffToScene() {
    final puffNode = ARKitNode(
      geometry: ARKitBox(
        width: 0.1,
        height: 0.1,
        length: 0.1,
        materials: [
          ARKitMaterial(
            diffuse: ARKitMaterialProperty.image('assets/puffs/puff_${widget.puffId}.png'),
          ),
        ],
      ),
      position: vector.Vector3(0, 0, -0.5),
    );
    
    arkitController.add(puffNode);
  }
}