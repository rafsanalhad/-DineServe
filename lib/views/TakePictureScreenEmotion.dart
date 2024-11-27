import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'DisplayPictureScreenEmotion.dart';
import 'dart:io';

class TakePictureScreenEmotion extends StatefulWidget {
  const TakePictureScreenEmotion({Key? key}) : super(key: key);

  @override
  TakePictureScreenEmotionState createState() => TakePictureScreenEmotionState();
}

class TakePictureScreenEmotionState extends State<TakePictureScreenEmotion> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      if (mounted) {
        setState(() {
          _controller = controller;
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Error'),
        content: const Text('Unable to initialize camera. Please check permissions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    if (!_isCameraInitialized) return;

    setState(() {
      _isFlashOn = !_isFlashOn;
      _controller?.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    });
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized) return;

    try {
      final image = await _controller!.takePicture();

      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreenEmotion(
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to take picture')),
      );
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          final camHeight = width * 4 / 3; // Standard 4:3 aspect ratio

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: (height - camHeight) / 2,
                child: SizedBox(
                  width: width,
                  height: camHeight,
                  child: CameraPreview(_controller!),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingActionButton(
                    backgroundColor: Colors.white.withOpacity(0.5),
                    onPressed: _takePicture,
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}