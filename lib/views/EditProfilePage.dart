import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../controller/AuthController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  File? _selectedImage; 
  Uint8List? _imageBytes; 

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
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
     Uri.parse(baseUrl + '/profil?user_id=${_authController.username.value}'),
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


  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      if (kIsWeb) {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final bytes =
              await pickedFile.readAsBytes(); 
          setState(() {
            _selectedImage = File(pickedFile
                .path); 
            _imageBytes = bytes; 
          });
        } else {
          print('No image selected');
        }
      } else {
        final pickedFile = await picker.pickImage(
            source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _selectedImage = File(
                pickedFile.path);
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
       Uri.parse(baseUrl + '/profil/update'),
    );

    request.fields['user_id'] = _authController.username.value;
    request.fields['username'] = usernameController.text;
    request.fields['email'] = emailController.text;

    if (_selectedImage != null) {
      if (kIsWeb) {
        var pic = await http.MultipartFile.fromBytes(
          'file',
          _imageBytes!,
          filename: 'profile_picture.jpg',
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
        _authController.setEmail(emailController.text);
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
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: kIsWeb
                              ? (_imageBytes != null
                                  ? Image.memory(_imageBytes!).image
                                  : NetworkImage(
                                          baseUrl + '/uploads/$profilePicture')
                                      as ImageProvider)
                              : (_selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : NetworkImage(
                                          baseUrl + '/uploads/$profilePicture')
                                      as ImageProvider),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Username field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    // Email field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
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
                    ),
                    SizedBox(height: 20),
                    // Save Changes Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        child: Text(
                          "Save Changes",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color(0xFF18654A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Kembali Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Return",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.grey[400],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
