// features/ar_preview/presentation/screens/ar_puff_screen.dart
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

/// A screen that provides an AR preview of a curry puff in the real world.
/// 
/// This widget uses AR Flutter Plugin to render a 3D model of a curry puff
/// in augmented reality. Users can place the puff in their environment and
/// view it from different angles.
class ARPuffScreen extends StatefulWidget {
  /// The unique identifier of the curry puff to display in AR.
  /// 
  /// This ID is used to load the correct 3D model from the assets
  /// directory in the format 'assets/models/puff_{puffId}.glb'.
  final int puffId;

  /// Creates an AR preview screen for a specific curry puff.
  /// 
  /// The [puffId] parameter is required and must correspond to an existing
  /// 3D model in the assets directory.
  const ARPuffScreen({required this.puffId, super.key});

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
      customPlaneTexturePath: 'assets/triangle.png',
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