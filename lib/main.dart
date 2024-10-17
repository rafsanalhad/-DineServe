import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'TakePictureScreen.dart';
import 'CardLoadingApp.dart';
import 'ButtonCamera.dart';
import 'HomePage.dart';
import 'StartScreen.dart';
import 'LoginPage.dart';
import 'SignUpPage.dart';
import 'ProfilePage.dart';
import 'History.dart';
import 'TakePictureScreenEmotion.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      // Define routes here
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/camera': (context) => TakePictureScreen(),
        '/loading': (context) => const CardLoadingApp(),
        '/profile': (context) => ProfilePage(),
        '/history':(context) => History(),
        '/cameraEmotion': (context) => TakePictureScreenEmotion(),
      },
    ),
  );
}
