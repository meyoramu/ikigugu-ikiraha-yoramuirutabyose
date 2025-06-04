// features/social_sharing/presentation/screens/social_share_screen.dart
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

/// A screen that allows users to record and share videos of their curry puffs.
/// 
/// This screen provides:
/// * Camera access for video recording
/// * Video preview functionality
/// * Social media sharing capabilities
/// * Automatic recording limits (15 seconds)
/// * Error handling and retry options
class SocialShareScreen extends StatefulWidget {
  /// Creates a screen for recording and sharing curry puff videos.
  /// 
  /// This screen uses the device's camera to record videos and provides
  /// options to preview and share them on various social media platforms.
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
  XFile? _lastRecordedVideo;
  bool _isSharing = false;

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
        _lastRecordedVideo = file;
        await _initializeVideoPlayer(file);
      } else {
        await _initializeControllerFuture;
        await _cameraController!.startVideoRecording();
        setState(() {
          _isRecording = true;
          _videoController?.dispose();
          _videoController = null;
          _lastRecordedVideo = null;
        });
        
        // Stop after 15 seconds
        Future.delayed(const Duration(seconds: 15), () async {
          if (_isRecording && mounted) {
            final file = await _cameraController!.stopVideoRecording();
            setState(() => _isRecording = false);
            _lastRecordedVideo = file;
            await _initializeVideoPlayer(file);
          }
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error recording video: $e');
    }
  }

  Future<void> _shareVideo() async {
    if (_lastRecordedVideo == null) {
      setState(() => _errorMessage = 'No video available to share');
      return;
    }

    try {
      setState(() => _isSharing = true);

      final file = File(_lastRecordedVideo!.path);
      if (!await file.exists()) {
        throw Exception('Video file not found');
      }

      final result = await Share.share(
        'Check out my delicious curry puff! 🥟✨ #CurryPuffMaster',
        subject: 'My Curry Puff Creation',
      );

      if (mounted) {
        setState(() => _isSharing = false);
        
        if (result.status == ShareResultStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video shared successfully!')),
          );
        } else if (result.status == ShareResultStatus.dismissed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sharing cancelled')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSharing = false;
          _errorMessage = 'Error sharing video: $e';
        });
      }
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
          if (_videoController != null && !_isSharing)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareVideo,
              tooltip: 'Share your puff video',
            ),
          if (_isSharing)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_videoController!.value.isPlaying) {
                          _videoController!.pause();
                        } else {
                          _videoController!.play();
                        }
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                        if (!_videoController!.value.isPlaying)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                      ],
                    ),
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
                if (!_isSharing)
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