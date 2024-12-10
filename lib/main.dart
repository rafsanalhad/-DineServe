import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'views/TakePictureScreen.dart';
import 'views/CardLoadingApp.dart';
import 'views/ButtonCamera.dart';
import 'views/HomePage.dart';
import 'views/StartScreen.dart';
import 'views/EditProfilePage.dart';
import 'views/LoginPage.dart';
import 'views/SignUpPage.dart';
import 'views/ProfilePage.dart';
import 'views/History.dart';
import 'views/ReservationPage.dart';
import 'views/TakePictureScreenEmotion.dart';
import 'views/ReviewsPage.dart';
import 'controller/reservation_controller.dart';
import 'controller/AuthController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;
import 'views/Payment.dart';
import 'views/TentangKami.dart';
import 'views/AdminPage.dart';
import 'views/ProfileAdmin.dart';
import 'views/RefundPage.dart';
import 'views/NotificationScreen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  await dot_env.dotenv.load(fileName: ".env");

  // Initialize the controller
  Get.put(ReservationController());
   Get.put(AuthController());

  runApp(
    GetMaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const StartScreen()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignUpPage()),
        GetPage(name: '/reservation', page: () => ReservationPage()),
        GetPage(name: '/loading', page: () => const CardLoadingApp()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/editProfile', page: () => EditProfilePage()),
        GetPage(name: '/history', page: () => History()),
        GetPage(name: '/reviews', page: () => ReviewsPage()), 
        GetPage(name: '/payment', page: () => Payment()),
        GetPage(name: '/cameraEmotion', page: () => TakePictureScreenEmotion()),
        GetPage(name: '/tentangKami', page: () => TentangKami()),
        GetPage(name: '/admin', page: () => AdminPage()),
        GetPage(name: '/profileAdmin', page: () => ProfileAdmin()),
        GetPage(name: '/refund', page: () => RefundPage()),
        GetPage(name: '/notification', page: () => NotificationScreen()),
      ],
    ),
  );
}
