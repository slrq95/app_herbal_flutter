import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:app_herbal_flutter/dio/dio_get.dart'; // Import DioGet for fetching data
=======
import 'package:app_herbal_flutter/src/api/provider/clinical_history/clinical_history_services.dart';

>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)
class ClinicalHistoryProvider extends ChangeNotifier {
  bool isDataFetched = false;
  bool isLoading = false;

<<<<<<< HEAD
TextEditingController clinicalHistoryController = TextEditingController();
TextEditingController patientCharacteristicsController = TextEditingController();
TextEditingController consultReasonController = TextEditingController();
=======
  TextEditingController clinicalHistoryController = TextEditingController();
  TextEditingController patientCharacteristicsController = TextEditingController();
  TextEditingController consultReasonController = TextEditingController();
>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)

  void clearData() {
    clinicalHistoryController.clear();
    patientCharacteristicsController.clear();
    consultReasonController.clear();
    isDataFetched = false;
    notifyListeners();
  }

<<<<<<< HEAD
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
=======
  Future<void> fetchClinicalHistory(dynamic patientId) async {
    isLoading = true;
    notifyListeners();

    try {
      final history = await ClinicalHistoryService.fetchClinicalHistory(int.parse(patientId));

      if (history.isNotEmpty) {
        clinicalHistoryController.text = history['clinical_history'] ?? '';
        patientCharacteristicsController.text = history['patient_characteristics']['details'] ?? '';
        consultReasonController.text = history['consult_reason'] ?? '';

        isDataFetched = true;
      }
    } catch (e) {
      debugPrint("Error fetching clinical history: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> createClinicalHistory(dynamic patientId) async {
    final success = await ClinicalHistoryService.createClinicalHistory(
      patientId,
      clinicalHistoryController.text,
      patientCharacteristicsController.text,
      consultReasonController.text,
    );

    if (success) {
      isDataFetched = true;
      notifyListeners();
    }
    return success;
  }

>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)
  @override
  void dispose() {
    clinicalHistoryController.dispose();
    patientCharacteristicsController.dispose();
    consultReasonController.dispose();
    super.dispose();
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)
