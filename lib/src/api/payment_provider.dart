import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
class PaymentProvider extends ChangeNotifier {
  double abonosRealizados = 0.0;  
  double abonosPendientes = 0.0;  
  List<Map<String, dynamic>> treatmentPlans = []; // Stores id_plan & price
  

  final Dio _dio = Dio(); // ✅ Use Dio for API requests

Future<void> initialize(int patientId) async {
  treatmentPlans.clear(); // Avoid clearing if data exists
  await fetchTreatmentPlans(patientId: patientId); // ✅ Fix: Use named argument
  debugPrint("Treatment Plans (after assign): $treatmentPlans");
  notifyListeners();
}

Future<void> fetchTreatmentPlans({required dynamic patientId}) async {
  try {
    final response = await _dio.get('http://localhost:3000/get_treatment_plans', queryParameters: {
      'id_patient': patientId.toString(), // Pass the patientId as a query parameter
    });

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      debugPrint("Raw API Response: $data");

      var filteredPlans = data.map((plan) {
        double price = 0.0;
        if (plan["price"] is String) {
          price = double.tryParse(plan["price"].toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
        } else if (plan["price"] is num) {
          price = plan["price"].toDouble();
        }

        return {
          "id_plan": plan["id_plan"],
          "id_patient": plan["id_patient"],
          "body_part": plan["body_part"],
          "plan_treatment": plan["plan_treatment"],
          "price": price,
          "created_at":plan["created_at"]
        };
      }).toList();

      debugPrint("Filtered Treatment Plans (before assign): $filteredPlans");

      treatmentPlans = filteredPlans;

      abonosPendientes = treatmentPlans.fold(0.0, (sum, plan) => sum + plan["price"]);
      
      notifyListeners();

      debugPrint("NotifyListeners() called");
    }
  } catch (e) {
    debugPrint("Error fetching treatment plans: $e");
  }
}
  /// ✅ **Confirm Payment**
  void confirmAbono(double amount) {
    if (amount <= 0 || amount > abonosPendientes) {
      debugPrint("Error: Invalid payment amount");
      return;
    }
    abonosRealizados += amount;
    abonosPendientes -= amount;
    notifyListeners();
  }

  /// ✅ **Cancel Payment (Reset Values)**
Future<void> cancelAbono() async {
  abonosRealizados = 0.0;
  
  // Make sure to pass the patientId when calling fetchTreatmentPlans
  final patientId = treatmentPlans.isNotEmpty ? treatmentPlans.first["id_patient"] : 0;
  await fetchTreatmentPlans(patientId: patientId); // Pass the patientId here

  notifyListeners();
}

  /// ✅ **Get Treatment Plans for a Specific Patient**
  List<Map<String, dynamic>> getPatientTreatmentPlans(dynamic patientId) {
    return treatmentPlans.where((plan) => plan["id_patient"] == patientId).toList();
  }
}