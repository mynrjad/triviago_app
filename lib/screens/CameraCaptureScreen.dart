import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/bloc_game.dart';
import '../bloc/bloc_game_event.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({Key? key}) : super(key: key);

  @override
  _CameraCaptureScreenState createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    // Initialize the controller and store the Future for later use.
    _initializeControllerFuture = _cameraController?.initialize();

    // After initializing the camera, trigger a rebuild to display the camera preview.
    setState(() {});
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await _cameraController?.takePicture();

      if (image != null) {
        // Trigger the StartGame event
        context.read<GameBloc>().add(StartGame());

        // Use GoRouter to navigate to the GameScreen
        GoRouter.of(context)
            .go('/game', extra: image); // Pass the XFile directly as an extra
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CameraPreview(_cameraController!), // CameraPreview should fill the whole space
                ),
                // Add your other UI components here, if any, they will be layered on top of the camera preview.
              ],
            );
          } else if (snapshot.hasError) {
            // If we run into an error, display it to the user.
            return Text('Error: ${snapshot.error}');
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Button to take the picture
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }



  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
