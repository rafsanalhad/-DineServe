import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topLeft,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF18654A), Color(0xFF30CB95)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Selamat Datang',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                'Silahkan daftar untuk melanjutkan reservasi anda',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(color: Colors.white),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 150,
                left: 15,
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: MediaQuery.of(context).size.height - 250,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(
                              0, 2),
                        ),
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 20, top: 20),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 20, top: 20),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                     
                            TextField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: const Icon(Icons.person,
                                    color: Color(0xFF18654A)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 16.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF18654A),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                          
                            TextField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                prefixIcon: const Icon(Icons.person,
                                    color: Color(0xFF18654A)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 16.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF18654A),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                        
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: const Icon(Icons.person,
                                    color: Color(0xFF18654A)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 16.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF18654A),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                         
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon:
                                    const Icon(Icons.lock, color: Color(0xFF18654A)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 16.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF18654A),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),

                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF18654A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                              
                                  String firstName = _firstNameController.text;
                                  String lastName = _lastNameController.text;
                                  String username = _usernameController.text;
                                  String password = _passwordController.text;

                                  print(
                                      'First Name: $firstName, Last Name: $lastName, Username: $username, Password: $password');
                                },
                                child: GestureDetector(
                                    onTap:() => Navigator.pushNamed(context, '/home'),
                                    child: const Text('Sign Up',
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
