// features/social_sharing/presentation/screens/social_share_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class SocialShareScreen extends StatefulWidget {
  const SocialShareScreen({super.key});

  @override
  State<SocialShareScreen> createState() => _SocialShareScreenState();
}

class _SocialShareScreenState extends State<SocialShareScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  bool _isRecording = false;
  VideoPlayerController? _videoController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = 'No cameras found');
        return;
      }

      final controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      _cameraController = controller;
      _initializeControllerFuture = controller.initialize();

      await _initializeControllerFuture;
      if (mounted) setState(() {});
    } catch (e) {
      setState(() => _errorMessage = 'Failed to initialize camera: $e');
    }
  }

  Future<void> _toggleRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      setState(() => _errorMessage = 'Camera not initialized');
      return;
    }

    try {
      if (_isRecording) {
        final file = await _cameraController!.stopVideoRecording();
        setState(() => _isRecording = false);
        await _initializeVideoPlayer(file);
      } else {
        await _initializeControllerFuture;
        await _cameraController!.startVideoRecording();
        setState(() {
          _isRecording = true;
          _videoController?.dispose();
          _videoController = null;
        });
        
        // Stop after 15 seconds
        Future.delayed(const Duration(seconds: 15), () async {
          if (_isRecording && mounted) {
            final file = await _cameraController!.stopVideoRecording();
            setState(() => _isRecording = false);
            await _initializeVideoPlayer(file);
          }
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error recording video: $e');
    }
  }

  Future<void> _initializeVideoPlayer(XFile file) async {
    try {
      final controller = VideoPlayerController.file(File(file.path));
      await controller.initialize();
      if (mounted) {
        setState(() {
          _videoController = controller;
          _videoController?.play();
          _videoController?.setLooping(true);
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error playing video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Your Puff'),
        actions: [
          if (_videoController != null)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // TODO: Implement sharing functionality
              },
            ),
        ],
      ),
      body: _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _errorMessage = null);
                        _initializeCamera();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                if (_videoController != null && _videoController!.value.isInitialized)
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                else if (_cameraController != null)
                  FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_cameraController!);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                else
                  const Center(child: CircularProgressIndicator()),
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
                        size: 32,
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
    _cameraController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}