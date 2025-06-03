// features/ar_preview/presentation/screens/ar_puff_screen.dart
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARPuffScreen extends StatefulWidget {
  final int puffId;

  const ARPuffScreen({super.key, required this.puffId});

  @override
  State<ARPuffScreen> createState() => _ARPuffScreenState();
}

class _ARPuffScreenState extends State<ARPuffScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  bool isPuffPlaced = false;

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Puff Preview'),
      ),
      body: ARView(
        onARViewCreated: onARViewCreated,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isPuffPlaced) {
            _addPuffToScene();
            setState(() => isPuffPlaced = true);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    
    arSessionManager!.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      customPlaneTexturePath: "assets/triangle.png",
      showWorldOrigin: true,
    );
    arObjectManager!.onInitialize();
  }

  Future<void> _addPuffToScene() async {
    if (arObjectManager != null) {
      final puffNode = ARNode(
        type: NodeType.localGLTF2,
        uri: 'assets/models/puff_${widget.puffId}.glb',
        scale: vector.Vector3.all(0.2),
        position: vector.Vector3(0, 0, -0.5),
        rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
      );
      
      bool? didAddNode = await arObjectManager!.addNode(puffNode);
      if (didAddNode!) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Puff placed in AR!')),
        );
      }
    }
  }
}