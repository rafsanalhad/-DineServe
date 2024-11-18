import 'package:get/get.dart';

class AuthController extends GetxController {
  var id = 0.obs; // id akan disimpan sebagai observables
  var username = ''.obs; // email akan disimpan sebagai observables
  
  void setUsername(String newUsername) {
    username.value = newUsername;
  }
  void setId(int newId) {
    id.value = newId;
  }
}