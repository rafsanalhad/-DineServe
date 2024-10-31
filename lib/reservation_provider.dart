import 'package:dineserve/ListReservasi.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class ReservationProvider with ChangeNotifier {
  List<ListReservasi> _reservations = [];

  List<ListReservasi> get reservations => _reservations;

  void addReservation(ListReservasi reservation) {
    _reservations.insert(0, reservation);
    notifyListeners();
  }

  void updateReservation(String id, ListReservasi updatedReservation) {
    final index = _reservations.indexWhere((res) => res.id == id);
    if (index != -1) {
      _reservations[index] = updatedReservation;
      notifyListeners();
    }
  }

  void deleteReservation(String id) {
    _reservations.removeWhere((res) => res.id == id);
    notifyListeners();
  }
}
