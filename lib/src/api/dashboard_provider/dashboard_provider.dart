import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  double _totalAttended = 45;
  double _totalNotAttended = 12;// fetched data from my backend API
  double _totalPayments = 10000;
  double _totalRemaining = 3000;

  double get totalAttended => _totalAttended;
  double get totalNotAttended => _totalNotAttended;
  double get totalPayments => _totalPayments;
  double get totalRemaining => _totalRemaining;

  void loadCitasData() {
    _totalAttended = 30; // Replace with API or DB call
    _totalNotAttended = 10; // Replace with API or DB call
    notifyListeners();
  }

  void loadAbonosData() {
    _totalPayments = 20000; // Replace with API or DB call
    _totalRemaining = 5000; // Replace with API or DB call
    notifyListeners();
  }
}
