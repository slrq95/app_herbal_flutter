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
            "created_at": plan["created_at"]
          };
        }).toList();
      }
    } catch (e) {
      debugPrint("Error fetching treatment plans: $e");
    }
    return [];
  }
}
