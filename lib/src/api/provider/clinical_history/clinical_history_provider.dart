import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/dio/dio_get.dart'; // Import DioGet for fetching data
class ClinicalHistoryProvider extends ChangeNotifier {
  bool isDataFetched = false;
  bool isLoading = false;

TextEditingController clinicalHistoryController = TextEditingController();
TextEditingController patientCharacteristicsController = TextEditingController();
TextEditingController consultReasonController = TextEditingController();

  void clearData() {
    clinicalHistoryController.clear();
    patientCharacteristicsController.clear();
    consultReasonController.clear();
    isDataFetched = false;
    notifyListeners();
  }

Future<void> fetchClinicalHistory(dynamic patientId) async {
  isLoading = true;
  notifyListeners();

  try {
    final dioGet = DioGet();
    final clinicalHistory = await dioGet.fetchClinicalHistory(int.parse(patientId));

    if (clinicalHistory.isNotEmpty) {
      final history = clinicalHistory[0];

      // Assign text to the controllers correctly
      clinicalHistoryController.text = history['clinical_history'] ?? '';
      patientCharacteristicsController.text = history['patient_characteristics']['details'] ?? '';
      consultReasonController.text = history['consult_reason'] ?? '';

      isDataFetched = true;
    }
  } catch (e) {
    print("Error fetching clinical history: $e");
  }

  isLoading = false;
  notifyListeners();
}
  @override
  void dispose() {
    clinicalHistoryController.dispose();
    patientCharacteristicsController.dispose();
    consultReasonController.dispose();
    super.dispose();
  }
}
