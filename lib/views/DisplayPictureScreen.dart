import 'dart:io';

import 'package:provider/provider.dart';

import '../provider/reservation_provider.dart';
import 'package:flutter/material.dart';
import '../models/ListReservasi.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  // Daftar untuk menyimpan data reservasi
  List<ListReservasi> daftarReservasi = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Image.file(
                File(widget.imagePath),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Face Attendance',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF18654A)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text('Wajah Valid',
                                    style: TextStyle(
                                        color: Color(0xFF949494),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400)),
                                Text('Benar',
                                    style: TextStyle(color: Color(0xFF18654A))),
                              ],
                            ),
                            SizedBox(
                              height: 13,
                              child: VerticalDivider(color: Color(0xFF18654A)),
                            ),
                            Column(
                              children: [
                                Text('Status Pengguna',
                                    style: TextStyle(
                                        color: Color(0xFF949494),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400)),
                                Text('Baru',
                                    style: TextStyle(color: Color(0xFF18654A))),
                              ],
                            ),
                            SizedBox(
                              height: 13,
                              child: VerticalDivider(color: Color(0xFF18654A)),
                            ),
                            Column(
                              children: [
                                Text('Status Kehadiran',
                                    style: TextStyle(
                                        color: Color(0xFF949494),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400)),
                                Text('Hadir',
                                    style: TextStyle(color: Color(0xFF18654A))),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Tambahkan data reservasi ke dalam daftar
                    final reservationProvider =
                        Provider.of<ReservationProvider>(context,
                            listen: false);
                    final newReservation = ListReservasi(
                      id: DateTime.now().toString(),
                      nama: 'Rizky Arifiansyah',
                      tgl: '12/12/2024',
                      jam: '12:00',
                      status: 'Hadir',
                    );

                    reservationProvider.addReservation(newReservation);
                    Navigator.pushNamed(
                      context,
                      '/history',
                      arguments: {
                        'id': 1,
                        'nama': 'Rizky Arifiansyah',
                        'tgl': '12/12/2021',
                        'jam': '12:00',
                        'status': 'Hadir',
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF18654A),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Lakukan Reservasi'),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
