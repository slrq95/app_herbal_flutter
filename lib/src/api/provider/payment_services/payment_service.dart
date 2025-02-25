import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PaymentService {
  final Dio _dio = Dio();

  /// Fetch treatment plans for a given patient
  Future<List<Map<String, dynamic>>> fetchTreatmentPlans(dynamic patientId) async {
    try {
      final response = await _dio.get('http://localhost:3000/get_treatment_plans', queryParameters: {
        'id_patient': patientId.toString(),
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        return data.map((plan) {
          dynamic price = 0.0;
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
            "created_at": plan["created_at"],
            "updated_at": plan["updated_at"],
            "note":plan["note"]
          };
        }).toList();
      }
    } catch (e) {
      debugPrint("Error fetching treatment plans: $e");
    }
    return [];
  }

Future<void> addPayment(int patientId, dynamic actualPayment) async {
  try {
    final response = await _dio.post('http://localhost:3000/add_payment', data: {
      "id_patient": patientId,
      "actual_payment": actualPayment,
      "created_at": DateTime.now().toIso8601String(),
    });

    debugPrint('Payment added: ${response.data}');
  } catch (e) {
    debugPrint('Error adding payment: $e');
  }
}

Future<double> fetchTotalPayment(int idPatient) async {
  try {
    final response = await _dio.get('http://localhost:3000/get_total_payment/$idPatient');

    if (response.statusCode == 200) {
      dynamic total = response.data['total_payment'];

      // Convert String to double safely
      if (total is String) {
        return double.tryParse(total) ?? 0.0;
      } else if (total is num) {
        return total.toDouble();
      } else {
        throw Exception('Invalid data type for total_payment');
      }
    } else {
      throw Exception('Failed to fetch total payments');
    }
  } catch (e) {
    debugPrint("Error fetching total payments: $e");
    return 0.0; // Return a default value to prevent crashes
  }
}

}
