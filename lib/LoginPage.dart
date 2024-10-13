import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      body: SafeArea(
          child: Container(
              child: Stack(
        children: [
          Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              padding: EdgeInsets.only(top: 60),
              decoration: BoxDecoration(
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
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Selamat Datang',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                'Silahkan login untuk melanjutkan reservasi anda',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(color: Colors.white),
                  )
                ],
              )),
          Positioned(
            top: 150,
            left: 15,
            child: Container(
                width: MediaQuery.of(context).size.width - 30,
                height: MediaQuery.of(context).size.height - 370,
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
                        offset: Offset(
                            0, 2), // Perpindahan shadow dari posisi widget
                      ),
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/login'),
                          child: Container(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/signup'),
                          child: Container(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon:
                                  Icon(Icons.person, color: Color(0xFF18654A)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 16.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Color(0xFF18654A),
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),

                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon:
                                  Icon(Icons.lock, color: Color(0xFF18654A)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 16.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Color(0xFF18654A),
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 0),
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 5),
                                        SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: Checkbox(
                                            value: false,
                                            onChanged: (value) {
                                              // setState(() {
                                              //   _rememberMe = value!;
                                              // });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Remember Me',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )),
                                Container(
                                  margin: EdgeInsets.only(top: 0),
                                  child: TextButton(
                                      onPressed: () {
                                        // Aksi ketika tombol Forgot Password ditekan
                                        // Misalnya, navigasi ke halaman reset password
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Forgot Password'),
                                              content: Text(
                                                  'Reset link has been sent to your email.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Tutup dialog
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text('Forgot Password?',
                                          style: TextStyle(
                                              color: Color(0xFF18654A),
                                              fontSize: 14))),
                                ),
                              ]), // Spasi sebelum tombol login
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF18654A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                // Aksi login ketika tombol ditekan
                                String username = _usernameController.text;
                                String password = _passwordController.text;

                                print(
                                    'Username: $username, Password: $password');
                              },
                              child: GestureDetector(
                                  onTap:() => Navigator.pushNamed(context, '/home'),
                                  child: Text('Login',
                                      style: TextStyle(color: Colors.white))),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          )
        ],
      ))),
    );
  }
}
