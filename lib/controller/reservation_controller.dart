import 'package:get/get.dart';
import '../models/ListReservasi.dart';

class ReservationController extends GetxController {
  var reservations = <ListReservasi>[].obs;

  void addReservation(ListReservasi reservation) {
    reservations.insert(0, reservation);
  }

  void updateReservation(String id, ListReservasi updatedReservation) {
    final index = reservations.indexWhere((res) => res.id == id);
    if (index != -1) {
      reservations[index] = updatedReservation;
    }
  }

  void deleteReservation(String id) {
    reservations.removeWhere((res) => res.id == id);
  }
}