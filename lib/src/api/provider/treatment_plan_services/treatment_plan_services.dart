import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class TreatmentPlanService {
  final Dio dio = Dio();

  Future<void> saveTreatmentPlan(List<Map<String, dynamic>> treatments) async {
    try {
      for (var treatment in treatments) {
        final response = await dio.post(
          'http://localhost:3000/add_treatment_plan',
          data: {
            'id_patient': treatment['id_patient'],
            'body_part': treatment['bodyPart'],
            'plan_treatment': treatment['treatment'],
            'price': treatment['price'],
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': null,
          },
        );

        if (response.statusCode == 201) {
          debugPrint('Treatment plan saved successfully for patient ${treatment['id_patient']}!');
        } else {
          debugPrint('Failed to save treatment plan');
        }
      }
    } catch (e) {
      debugPrint('Error saving treatment plan: $e');
    }
  }
}
