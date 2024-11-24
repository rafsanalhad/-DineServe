import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var id = 0.obs;
  var username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAuthData(); // Load data saat controller diinisialisasi
  }

  Future<void> loadAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      id.value = prefs.getInt('user_id') ?? 0;
      username.value = prefs.getString('username') ?? '';
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

  // Method untuk logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('username');
      id.value = 0;
      username.value = '';
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Getter untuk mengecek status login
  bool get isLoggedIn => id.value != 0 && username.value.isNotEmpty;
}
