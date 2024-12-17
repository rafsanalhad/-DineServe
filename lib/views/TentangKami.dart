import 'package:flutter/material.dart';

class TentangKami extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF459171),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF459171),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/hero_img.png', // Ganti dengan path gambar yang sesuai
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'DineServe',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'A modern restaurant reservation solution that combines the latest technology to provide the best experience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Vision & Mission Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our Vision',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'To become the number one restaurant reservation platform trusted by millions of users worldwide.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Our Mission',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '- Make it easier for users to make restaurant reservations.\n'
                    '- Use advanced technology to enhance service efficiency.\n'
                    '- Provide the best experience for customers and restaurant partners.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),
                  // Our Team Section
                  const Text(
                    'Our Team',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Behind DineServe is a team of professionals dedicated to creating an exceptional reservation experience.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _teamMember(
                        imagePath: 'assets/images/profil.png',
                        name: 'Rafsan',
                        role: 'CEO',
                      ),
                      _teamMember(
                        imagePath: 'assets/images/profil.png',
                        name: 'Armand',
                        role: 'CTO',
                      ),
                      _teamMember(
                        imagePath: 'assets/images/profil.png',
                        name: 'Arno',
                        role: 'COO',
                      ),
                      _teamMember(
                        imagePath: 'assets/images/profil.png',
                        name: 'Natan',
                        role: 'CMO',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Footer Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF18654A),
              ),
              child: const Center(
                child: Text(
                  'DineServe © 2024 - All Rights Reserved',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamMember({
    required String imagePath,
    required String name,
    required String role,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Text(
          role,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
