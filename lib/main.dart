import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'views/TakePictureScreen.dart';
import 'views/CardLoadingApp.dart';
import 'views/ButtonCamera.dart';
import 'views/HomePage.dart';
import 'views/StartScreen.dart';
import 'views/LoginPage.dart';
import 'views/SignUpPage.dart';
import 'views/ProfilePage.dart';
import 'views/History.dart';
import 'views/TakePictureScreenEmotion.dart';
import 'package:provider/provider.dart';
import 'provider/reservation_provider.dart';

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
