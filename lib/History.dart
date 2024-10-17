import 'package:flutter/material.dart';

// Import kelas ListReservasi yang sudah ada
import 'ListReservasi.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
   final routeArgs = ModalRoute.of(context)?.settings.arguments;

final List<ListReservasi> daftarReservasi = [
  ListReservasi(
      id: '1',
      nama: 'Reservasi A',
      tgl: '2024-10-17',
      jam: '10:00',
      status: 'Confirmed'),
  ListReservasi(
      id: '2',
      nama: 'Reservasi B',
      tgl: '2024-10-18',
      jam: '12:00',
      status: 'Pending'),
  ListReservasi(
      id: '3',
      nama: 'Reservasi C',
      tgl: '2024-10-19',
      jam: '14:00',
      status: 'Cancelled'),
];

// Menambahkan reservasi baru hanya jika argumen ada
if (routeArgs != null) {
  // Melakukan cast ke Map<String, dynamic>
  final args = routeArgs as Map<String, dynamic>;

  // Mengambil nilai dari argumen
  int id = args['id'];
  String nama = args['nama'];
  String tgl = args['tgl'];
  String jam = args['jam'];
  String status = args['status'];

  // Menambahkan reservasi baru
  daftarReservasi.insert(0, ListReservasi(
          id: id.toString(), nama: nama, tgl: tgl, jam: jam, status: status));
} else {
  // Jika tidak ada argumen, daftarReservasi hanya berisi 3 data awal
  print('Tidak ada argumen yang diterima, hanya menggunakan data default.');
}
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF7F7F7),
        title: const Text('History'),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF7F7F7),
          ),
          child: ListView.builder(
            itemCount: daftarReservasi.length,
            itemBuilder: (context, index) {
              final reservasi = daftarReservasi[index];

              return Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 4), // Shadow pada posisi bawah
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.asset('assets/images/profil.png',
                        width: 40, height: 40),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reservasi.nama,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          Row(
                            children: [
                              Text('${reservasi.jam}, ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              Text(reservasi.tgl,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            reservasi.status,
                            style: TextStyle(
                              color: reservasi.status == 'Confirmed'
                                  ? Colors.green
                                  : reservasi.status == 'Pending'
                                      ? Colors.orange
                                      : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
