import 'package:get/get.dart';

class AuthController extends GetxController {
  var username = ''.obs; // email akan disimpan sebagai observables
  
  void setUsername(String newUsername) {
    username.value = newUsername;
  }
}