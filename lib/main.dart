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
import 'package:provider/provider.dart';
import 'reservation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ReservationProvider(),
      child: MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const StartScreen(),
          '/home': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/camera': (context) => TakePictureScreen(),
          '/loading': (context) => const CardLoadingApp(),
          '/profile': (context) => ProfilePage(),
          '/history': (context) => History(),
          '/cameraEmotion': (context) => TakePictureScreenEmotion(),
        },
      ),
    ),
  );
}
