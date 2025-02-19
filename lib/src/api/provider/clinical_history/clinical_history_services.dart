import 'package:app_herbal_flutter/dio/dio_get.dart';
import 'package:app_herbal_flutter/dio/dio_post.dart';
import 'package:flutter/foundation.dart';

class ClinicalHistoryService {
  static Future<Map<String, dynamic>> fetchClinicalHistory(int patientId) async {
    try {
      final dioGet = DioGet();
      final clinicalHistory = await dioGet.fetchClinicalHistory(patientId);

      return clinicalHistory.isNotEmpty ? clinicalHistory[0] : {};
    } catch (e) {
      debugPrint("Error fetching clinical history: $e");
      return {};
    }
  }

  static Future<bool> createClinicalHistory(
      dynamic patientId, String clinicalHistory, String patientCharacteristics, String consultReason) async {
    try {
      final dioService = DioService();

      Map<String, dynamic> clinicalHistoryData = {
        "id_patient": patientId,
        "clinical_history": clinicalHistory,
        "patient_characteristics": {
          "details": patientCharacteristics,
        },
        "consult_reason": consultReason,
        "created_at": DateTime.now().toIso8601String(),
      };

      final response = await dioService.postClinicalHistory(clinicalHistoryData);

      return response != null && response.statusCode == 201;
    } catch (e) {
      debugPrint("Error creating clinical history: $e");
      return false;
    }
  }
}