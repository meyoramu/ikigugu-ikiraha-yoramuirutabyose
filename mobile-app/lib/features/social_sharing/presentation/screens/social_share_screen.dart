// features/social_sharing/presentation/screens/social_share_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';

class SocialShareScreen extends StatefulWidget {
  const SocialShareScreen({super.key});

  @override
  State<SocialShareScreen> createState() => _SocialShareScreenState();
}

class _SocialShareScreenState extends State<SocialShareScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isRecording = false;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _cameraController.initialize();
    setState(() {});
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
    } else {
      await _initializeControllerFuture;
      final video = await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
      
      // Stop after 15 seconds
      Future.delayed(const Duration(seconds: 15), () async {
        if (_isRecording) {
          final file = await _cameraController.stopVideoRecording();
          setState(() {
            _isRecording = false;
            _videoController = VideoPlayerController.file(file);
            _videoController?.initialize().then((_) {
              setState(() {});
              _videoController?.play();
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Your Puff'),
      ),
      body: Stack(
        children: [
          if (_videoController != null && _videoController!.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          else
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _toggleRecording,
                backgroundColor: _isRecording ? Colors.red : Colors.white,
                child: Icon(
                  _isRecording ? Icons.stop : Icons.circle,
                  color: _isRecording ? Colors.white : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}