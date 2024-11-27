import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../controller/AuthController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Future<List<dynamic>> _reservations;
  final AuthController _authController = Get.find();
  int _selectedIndex = 0;
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  @override
  void initState() {
    super.initState();
    _reservations = fetchReservations();
  }

  Future<List<dynamic>> fetchReservations() async {
    final response = await http.get(
      Uri.parse(
          baseUrl + '/reservations?user_id=${_authController.id.value}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> reservations = json.decode(response.body);
      return reservations;
    } else {
      throw Exception('Failed to load reservations');
    }
  }
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
        backgroundColor: const Color(0xFFF7F7F7),
        title: const Text('History'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: _reservations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No reservations found'));
            } else {
              final reservations = snapshot.data!;
              return ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservasi = reservations[index];
                  return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Image(
                          image: AssetImage('assets/images/profil.png'),
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reservasi['name'] ??
                                    'No name available', // Handle null for 'details'
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${reservasi['time'] ?? 'No time available'}, ', // Handle null for 'time'
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    reservasi['date'] ??
                                        'No date available', // Handle null for 'date'
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                    "Jumlah orang: ${(reservasi['guest_count'] ?? 0).toString()}",
                                    style: const TextStyle(
                                      color: Colors.green,
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
            }
          },
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
