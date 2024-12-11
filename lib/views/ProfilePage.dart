import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controller/AuthController.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePage> {
  bool pushNotifications = true;
  bool notifications = true;
  int _selectedIndex = 2;
  final AuthController _authController = Get.find();
  late String username = '';
  late String email = '';
  late String profilePicture = 'default.jpg';
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  @override
  void initState() {
    super.initState();
    _getProfile();
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
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        radius: 55,
                        backgroundImage:
                            NetworkImage(baseUrl + '/uploads/$profilePicture'),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "@$username",
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        email,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFE0FBE2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.store,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                        title: const Text('History'),
                        trailing: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFB8B8B8),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/history');
                        },
                      ),
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFE0FBE2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.headset_mic,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                        title: const Text('Kontak Support'),
                        trailing: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFB8B8B8),
                          ),
                        ),
                        onTap: () {
                          // Action untuk Kontak Support
                        },
                      ),
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFE0FBE2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                        title: const Text('Tentang Kami'),
                        trailing: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFB8B8B8),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/tentangKami');
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFE0FBE2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                        title: const Text('Edit Profile'),
                        trailing: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFB8B8B8),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/editProfile');
                        },
                      ),
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFE0FBE2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                        title: const Text('Logout'),
                        trailing: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFB8B8B8),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFF18654A), // primary green
        unselectedItemColor: const Color(0xFF18654A),
        onTap: _onItemTapped,
      ),
    );
  }
}
