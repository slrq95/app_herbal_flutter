import 'package:flutter/material.dart';


class PaymentProvider extends ChangeNotifier {
  double abonosRealizados = 0.0;  // values that will be fetched from my backend API using (express,NodeJs,Postgresql)
  double abonosPendientes = 1000.0;

  // Store initial values to allow canceling
  double initialAbonosRealizados = 0.0;
  double initialAbonosPendientes = 1000.0;

  void initialize() {
    initialAbonosRealizados = abonosRealizados;
    initialAbonosPendientes = abonosPendientes;
  }

  void confirmAbono(double amount) {
    abonosRealizados += amount;
    abonosPendientes -= amount;
    notifyListeners(); // Notify the UI to update
  }

  void cancelAbono() {
    abonosRealizados = initialAbonosRealizados;
    abonosPendientes = initialAbonosPendientes;
    notifyListeners(); // Notify UI to revert changes
  }
}