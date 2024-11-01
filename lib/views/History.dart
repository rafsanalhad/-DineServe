import 'package:dineserve/provider/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import kelas ListReservasi yang sudah ada
import '../models/ListReservasi.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('Home Page')),
    const Center(child: Text('History Page')),
    const Center(child: Text('Ulasan Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/history');
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Consumer<ReservationProvider>(
            builder: (context, reservationProvider, child) {
              final daftarReservasi = reservationProvider.reservations;

              return ListView.builder(
                itemCount: daftarReservasi.length,
                itemBuilder: (context, index) {
                  final reservasi = daftarReservasi[index];

                  return Container(
                    margin:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 4),
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
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: const Color(0xFF18654A),
        unselectedItemColor: const Color(0xFF18654A),
        onTap: _onItemTapped,
      ),
    );
  }
}
