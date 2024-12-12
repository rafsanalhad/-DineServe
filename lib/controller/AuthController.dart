import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var id = 0.obs;
  var username = ''.obs;
  var email = ''.obs;
  var role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAuthData();
  }

  Future<void> loadAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      id.value = prefs.getInt('user_id') ?? 0;
      username.value = prefs.getString('username') ?? '';
      role.value = prefs.getString('role') ?? '';
      email.value = prefs.getString('email') ?? '';
      print('Loaded username: ${username.value}'); // Debug print
    } catch (e) {
      print('Error loading auth data: $e');
    }
  }

  Future<void> setId(int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', value);
      id.value = value;
      print('Set ID: $value'); // Debug print
    } catch (e) {
      print('Error setting user ID: $e');
    }
  }

  Future<void> setUsername(String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', value);
      username.value = value;
      print('Set username: $value'); // Debug print
    } catch (e) {
      print('Error setting username: $e');
    }
  }

  Future<void> setRole(String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', value);
      role.value = value;
      print('Set role: $role'); // Debug print
    } catch (e) {
      print('Error setting role: $e');
    }
  }

  Future<void> setEmail(String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', value);
      email.value = value;
      print('Set email: $email');
    } catch (e) {
      print('Error setting email: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('user_id');
      await prefs.remove('username');
      await prefs.remove('role');
      await prefs.remove('email');
      id.value = 0;
      username.value = '';
      role.value = '';
      email.value = ''; 


      loadAuthData();

      print('Logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  bool get isLoggedIn => id.value != 0 && username.value.isNotEmpty;
}
