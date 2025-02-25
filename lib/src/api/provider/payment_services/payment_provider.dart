import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/payment_services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  double abonosRealizados = 0.0;
  double abonosPendientes = 0.0;
  double totalPayment = 0.0;  // New variable for total payments
  List<Map<String, dynamic>> treatmentPlans = [];
  final PaymentService _paymentService = PaymentService();

  /// Initialize the payment provider with patient data
Future<void> initialize(int patientId) async {
  treatmentPlans.clear();
  await fetchTreatmentPlans(patientId);
  await fetchTotalPayment(patientId);  // Fetch total payments
  // Now calculate abonosPendientes after data is fetched
  abonosPendientes = (treatmentPlans.fold(0.0, (sum, plan) => sum + plan["price"])) - totalPayment;
  notifyListeners();
}

  /// Fetch treatment plans using the PaymentService
  Future<void> fetchTreatmentPlans(int patientId) async {
    treatmentPlans = await _paymentService.fetchTreatmentPlans(patientId);
    abonosPendientes = (treatmentPlans.fold(0.0, (sum, plan) => sum + plan["price"]) - totalPayment);

    notifyListeners();
  }

  /// Fetch total payments from the backend
  Future<void> fetchTotalPayment(int patientId) async {
    totalPayment = (await _paymentService.fetchTotalPayment(patientId));
    notifyListeners();
  }

/// Confirm a payment
void confirmAbono(double amount) {
  if (amount <= 0 || amount > abonosPendientes) {
    debugPrint("Error: Invalid payment amount");
    return;
  }
  abonosRealizados += amount;
  // Recalculate abonosPendientes correctly
  abonosPendientes = (treatmentPlans.fold(0.0, (sum, plan) => sum + plan["price"])) - totalPayment ;
  notifyListeners();
}

  /// Cancel a payment (resets values)
  Future<void> cancelAbono() async {
    abonosRealizados = 0.0;
    final patientId = treatmentPlans.isNotEmpty ? treatmentPlans.first["id_patient"] : 0;
    await fetchTreatmentPlans(patientId);
    await fetchTotalPayment(patientId);  // Refresh total payments
    notifyListeners();
  }
void resetCurrentPayment() {
  abonosRealizados = 0.0;
  notifyListeners();
}

  /// Get the treatment plans for a specific patient
  List<Map<String, dynamic>> getPatientTreatmentPlans(int patientId) {
    return treatmentPlans.where((plan) => plan["id_patient"] == patientId).toList();
    
  }

}
