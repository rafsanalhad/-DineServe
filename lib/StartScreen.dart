import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF18654A), Color(0xFF30CB95)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center secara vertikal
              crossAxisAlignment: CrossAxisAlignment.center, // Center secara horizontal
              children: [
                Text(
                  'Mulai Reservasi Sekarang Dengan Mudah',
                  textAlign: TextAlign.center, // Center text secara horizontal
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10), // Spasi antar elemen
                Text(
                  'Lakukan Reservasi Dengan Pengenalan Wajah dengan cepat dan mudah',
                  textAlign: TextAlign.center, // Center text secara horizontal
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(height: 70), // Spasi sebelum gambar
                Container(
                  margin: EdgeInsets.only(right: 40),
                  child: Image.asset(
                    'assets/images/hero_img.png',
                    width: 320,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
               // Spasi sebelum tombol
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
                    child: Text('Mulai Sekarang', style: TextStyle(color: Color(0xFF18654A))),
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
