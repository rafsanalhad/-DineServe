import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: SafeArea(
                child: Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_hero.png'), // Lokasi gambar
                fit: BoxFit
                    .cover, // Mengatur gambar agar menutupi seluruh kontainer
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50), // Radius di sudut kiri bawah
                bottomRight: Radius.circular(50), // Radius di sudut kanan bawah
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Row(
                      children: [
                        Image.asset('assets/images/profil.png'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Text(
                                  'Rizky Arifiansyah',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Member',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ],
                            )),
                          ],
                        )
                      ],
                    )),
                    Icon(Icons.notifications_active_outlined, color: Colors.white)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Halo Food Hunter',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          Text('Mau Cari Informasi Apa Hari Ini?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11)),
                          Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                                  margin: const EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search),
                                      Text('Cari sesuatu disini', style: TextStyle(color: Colors.grey[400], fontSize: 12),)
                                    ],
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Image.asset('assets/images/hero_img.png',
                        width: 152, height: 200)
                  ],
                )
              ],
            ))
      ],
    ))));
  }
}
