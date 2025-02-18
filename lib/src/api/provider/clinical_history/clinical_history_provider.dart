import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/clinical_history/clinical_history_services.dart';

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

  @override
  void dispose() {
    clinicalHistoryController.dispose();
    patientCharacteristicsController.dispose();
    consultReasonController.dispose();
    super.dispose();
  }
}
