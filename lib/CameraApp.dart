import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Mendaftarkan observer
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Hapus observer
    _controller.dispose();
    super.dispose();
  }

  // Mengelola perubahan status siklus hidup aplikasi
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // Pastikan kamera sudah diinisialisasi
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Hentikan kamera jika aplikasi sedang tidak aktif
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Inisialisasi ulang kamera ketika aplikasi dilanjutkan
      _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera Example')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            print('Gambar disimpan di: ${image.path}');
          } catch (e) {
            print('Error mengambil gambar: $e');
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
