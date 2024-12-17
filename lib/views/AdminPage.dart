import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controller/AuthController.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;
  final AuthController _authController = Get.find();
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  late String username = '';
  late String email = '';
  late String profilePicture = 'default.jpg';

  List<dynamic> reservations = [];
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    _getProfile();
    _getAllReservations();
  }

  Future<void> _getProfile() async {
    final response = await http.get(
      Uri.parse(baseUrl + '/profil?user_id=${_authController.username.value}'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        username = data['username'];
        email = data['email'];

        if (data['profile_picture'] == null) {
          profilePicture = 'default.jpg';
        } else {
          profilePicture = data['profile_picture'];
        }
      });
    } else {
      print("Failed to load profile: ${response.body}");
    }
  }

  Future<void> _getAllReservations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservations?user_id=${_authController.id.value}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        reservations = jsonDecode(response.body);
      });
    } else {
      print("Failed to load reservations: ${response.body}");
    }
  }

  Future<void> _cancelReservation(String reservationId) async {
    final response =
        await http.delete(Uri.parse(baseUrl + '/reservations/$reservationId'));

    if (response.statusCode == 200) {
      setState(() {
        reservations
            .removeWhere((reservation) => reservation['id'] == reservationId);
      });
      print("Reservation cancelled successfully.");
      SuccessAlertBox(
        context: context,
        title: "Success",
        messageText: "Reservation cancelled successfully.",
        buttonColor: Colors.green,
        buttonText: "OK",
      );
    } else {
      print("Failed to cancel reservation: ${response.body}");
      DangerAlertBox(
        context: context,
        title: "Error",
        messageText: "Failed to cancel reservation: ${response.body}",
        buttonColor: Colors.green,
        buttonText: "OK",
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/admin');
        break;
      case 1:
        Navigator.pushNamed(context, '/refund');
        break;
      default:
        break;
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Menampilkan modal konfirmasi logout
                bool? confirmed = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Logout Confirmation"),
                      content: Text("Are you sure you want to logout?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop(false); // Tidak logout
                          },
                        ),
                        TextButton(
                          child: Text("Logout"),
                          onPressed: () {
                            Navigator.of(context).pop(true); // Ya, logout
                          },
                        ),
                      ],
                    );
                  },
                );

                // Jika user mengonfirmasi logout, jalankan proses logout
                if (confirmed == true) {
                  try {
                    await _authController.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  } catch (e) {
                    print("Error during logout: $e");
                  }
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile and Greeting Section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage(baseUrl + '/uploads/$profilePicture'),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Admin',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          'Manage the reservations and refunds here',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Reservation Section
                const Text('Reservations',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      var reservation = reservations[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text('Reservation ID: ${reservation['id']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${reservation['username']}'),
                              Text('Date: ${reservation['date']}'),
                              Text('Time: ${reservation['time']}'),
                              Text('Guests: ${reservation['guest_count']}'),
                              Text('Table: ${reservation['table_number']}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () async {
                              // Menampilkan modal konfirmasi reservasi
                              bool? confirmed = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Removal of Customer Reservation"),
                                    content: Text(
                                        "Are you sure you want to remove this reservation for this customer?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              false); // Tidak hapus reservasi
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Remove"),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(true); // Ya, hapus reservasi
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                              // Jika user mengonfirmasi reservasi, jalankan proses reservasi
                              if (confirmed == true) {
                                try {
                                  _cancelReservation(reservation['id']);
                                } catch (e) {
                                  print("Error cancel reservation: $e");
                                }
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
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
              icon: Icon(Icons.payment),
              label: 'Refund',
            ),
          ],
          selectedItemColor: const Color(0xFF18654A),
          unselectedItemColor: const Color(0xFF18654A),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
