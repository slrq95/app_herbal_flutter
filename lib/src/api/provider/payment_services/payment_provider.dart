import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/payment_services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  double abonosRealizados = 0.0;
  double abonosPendientes = 0.0;
  List<Map<String, dynamic>> treatmentPlans = [];
  final PaymentService _paymentService = PaymentService();

  /// Initialize the payment provider with patient data
  Future<void> initialize(int patientId) async {
    treatmentPlans.clear();
    await fetchTreatmentPlans(patientId);
    notifyListeners();
  }

  /// Fetch treatment plans using the PaymentService
  Future<void> fetchTreatmentPlans(int patientId) async {
    treatmentPlans = await _paymentService.fetchTreatmentPlans(patientId);
    abonosPendientes = treatmentPlans.fold(0.0, (sum, plan) => sum + plan["price"]);
    notifyListeners();
  }

  /// Confirm a payment
  void confirmAbono(double amount) {
    if (amount <= 0 || amount > abonosPendientes) {
      debugPrint("Error: Invalid payment amount");
      return;
    }
    abonosRealizados += amount;
    abonosPendientes -= amount;
    notifyListeners();
  }

  /// Cancel a payment (resets values)
  Future<void> cancelAbono() async {
    abonosRealizados = 0.0;
    final patientId = treatmentPlans.isNotEmpty ? treatmentPlans.first["id_patient"] : 0;
    await fetchTreatmentPlans(patientId);
    notifyListeners();
  }

  /// Get the treatment plans for a specific patient
  List<Map<String, dynamic>> getPatientTreatmentPlans(int patientId) {
    return treatmentPlans.where((plan) => plan["id_patient"] == patientId).toList();
  }
}
