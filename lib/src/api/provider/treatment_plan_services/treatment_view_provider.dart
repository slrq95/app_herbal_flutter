import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/treatment_plan_services/treatment_view_service.dart';

class TreatmentViewProvider with ChangeNotifier {

  final TreatmentViewService _treatmentViewService = TreatmentViewService();



    /// Initialize the payment provider with patient data
  Future<void> initialize(int patientId) async {
    treatmentPlans.clear();
    await fetchTreatmentViewPlans(patientId);
    notifyListeners();
  }

  // Fetch treatment notes for a specific patien
List<Map<String, dynamic>> _treatmentPlans = [];

List<Map<String, dynamic>> get treatmentPlans => _treatmentPlans;

Future<void> fetchTreatmentViewPlans(int patientId) async {
  try {
    _treatmentPlans = await _treatmentViewService.fetchTreatmentPlans(patientId);
    notifyListeners();
  } catch (e) {
    debugPrint("Error fetching treatment plans: $e");
  }
}

    /// Get the treatment plans for a specific patient
  List<Map<String, dynamic>> getPatientTreatmentViewPlans(int patientId) {
    return treatmentPlans.where((plan) => plan["id_patient"] == patientId).toList();
  }
}