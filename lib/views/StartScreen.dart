import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF18654A), Color(0xFF30CB95)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  // 'Mulai Reservasi Sekarang Dengan Mudah'
                  'Start Your Reservation Easily Now!',
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10), 
                const Text(
                  // 'Lakukan Reservasi Dengan Pengenalan Wajah dengan cepat dan mudah'
                  'Elevating Your Dining Experience with Emotion-Based Reviews',
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(height: 70), 
                Container(
                  margin: const EdgeInsets.only(right: 40),
                  child: Image.asset(
                    'assets/images/hero_img.png',
                    width: 320,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
              
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Get Started', style: TextStyle(color: Color(0xFF18654A))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
