import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // Untuk mengecek platform
import '../controller/AuthController.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthController _authController = Get.find();
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String profilePicture = 'default.jpg';
  bool isLoading = false;
  File? _selectedImage; // Untuk menyimpan gambar yang dipilih
  Uint8List? _imageBytes; // Untuk menyimpan gambar dalam bentuk byte untuk Web

  // Controller untuk text field
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _getProfile();
  }

  Future<void> _getProfile() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          'http://localhost:5000/profil?user_id=${_authController.username.value}'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        username = data['username'];
        email = data['email'];
        profilePicture = data['profile_picture'] ?? 'default.jpg';

        usernameController.text = username;
        emailController.text = email;


      });
    } else {
      print("Failed to load profile");
    }

    setState(() {
      isLoading = false;
    });
  }

  // Fungsi untuk memilih gambar baru
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      if (kIsWeb) {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final bytes =
              await pickedFile.readAsBytes(); // Membaca file sebagai bytes
          setState(() {
            _selectedImage = File(pickedFile
                .path); // Menyimpan gambar untuk preview (bisa berbeda untuk Web)
            _imageBytes = bytes; // Menyimpan gambar dalam bentuk byte untuk Web
          });
        } else {
          print('No image selected');
        }
      } else {
        final pickedFile = await picker.pickImage(
            source: ImageSource.gallery); // Untuk mobile (Android/iOS)
        if (pickedFile != null) {
          setState(() {
            _selectedImage = File(
                pickedFile.path); // Menyimpan gambar untuk preview di mobile
          });
        } else {
          print('No image selected');
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:5000/profil/update'),
    );

    request.fields['user_id'] = _authController.username.value;
    request.fields['username'] = usernameController.text;
    request.fields['email'] = emailController.text;

    // Jika password baru diisi, kirimkan password baru
    // if (newPasswordController.text.isNotEmpty) {
    //   if (newPasswordController.text == confirmPasswordController.text) {
    //     request.fields['password'] = newPasswordController.text;
    //   } else {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text("Passwords do not match")));
    //     setState(() {
    //       isLoading = false;
    //     });
    //     return;
    //   }
    // }

    // Jika ada gambar yang dipilih, unggah gambar tersebut
    if (_selectedImage != null) {
      if (kIsWeb) {
        // Untuk Web, kirimkan gambar dalam bentuk base64 atau MultipartFile
        var pic = await http.MultipartFile.fromBytes(
          'file',
          _imageBytes!,
          filename: 'profile_picture.jpg', // Berikan nama file
        );
        request.files.add(pic);
      } else {
        var pic =
            await http.MultipartFile.fromPath('file', _selectedImage!.path);
        request.files.add(pic);
      }
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Profile updated successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")));
        _authController.setUsername(usernameController.text);
      Navigator.pushNamed(context, '/profile');
    } else {
      print("Failed to update profile: ${response}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to update profile")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Color(0xFF18654A),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tampilkan foto profil
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage, // Memanggil fungsi pilih gambar
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: kIsWeb
                                ? (_imageBytes != null
                                    ? Image.memory(_imageBytes!).image
                                    : NetworkImage(
                                            'http://localhost:5000/uploads/$profilePicture')
                                        as ImageProvider)
                                : (_selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : NetworkImage(
                                            'http://localhost:5000/uploads/$profilePicture')
                                        as ImageProvider),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Username input
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Email input
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                     
                      SizedBox(height: 20),
                      // Save Changes Button
                      ElevatedButton(
                        onPressed: _updateProfile,
                        child: Text("Save Changes"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Cancel Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close EditProfilePage
                        },
                        child: Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
