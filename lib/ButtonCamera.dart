import 'package:flutter/material.dart';

class ButtonCamera extends StatelessWidget {
  const ButtonCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'), // Judul AppBar
        ),
        body: Center(
          // Mengatur posisi ButtonCamera di tengah layar
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Mengatur posisi kolom di tengah
            children: [
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/camera');
                  },
                ),
              ),
              const SizedBox(height: 8), // Jarak antara ikon dan teks
              const Text(
                'Take a Picture', // Teks di bawah ikon
                style:
                    TextStyle(fontSize: 16, color: Colors.black), // Gaya teks
              ),
            ],
          ),
        ),
      ),
    );
  }
}
