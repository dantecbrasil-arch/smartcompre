import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    iniciarCamera();
  }

  Future<void> iniciarCamera() async {
    try {
      final cameras = await availableCameras();

      debugPrint('CAMERAS ENCONTRADAS: ${cameras.length}');

      final camera = cameras.first;

      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
      );

      await _controller!.initialize();

      debugPrint('CAMERA INICIALIZADA');

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('ERRO CAMERA: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
  appBar: AppBar(
    title: const Text('Teste Camera'),
  ),
  body: CameraPreview(_controller!),
  floatingActionButton: FloatingActionButton(
    onPressed: () async {
      try {
        final foto = await _controller!.takePicture();

        debugPrint('====================');
        debugPrint('FOTO CAPTURADA');
        debugPrint('CAMINHO: ${foto.path}');
        debugPrint('====================');
      } catch (e) {
        debugPrint('ERRO FOTO: $e');
      }
    },
    child: const Icon(Icons.camera),
  ),
);
  }
}