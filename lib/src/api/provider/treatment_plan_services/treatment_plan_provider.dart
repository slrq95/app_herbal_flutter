import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/treatment_plan_services/treatment_plan_services.dart';

class TreatmentPlanProvider extends ChangeNotifier {
    final TreatmentPlanService _treatmentPlanService = TreatmentPlanService(); // Create an instance
  final TextEditingController bodyPartController = TextEditingController();
  final TextEditingController treatmentController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final List<Map<String, dynamic>> _treatments = [];
  double _totalPrice = 0.0;

  List<Map<String, dynamic>> get treatments => _treatments;
  double get totalPrice => _totalPrice;

  void addTreatment(String patientId) {
    double price = double.tryParse(priceController.text) ?? 0.0;

    _treatments.add({
      'id_patient': patientId,
      'bodyPart': bodyPartController.text,
      'treatment': treatmentController.text,
      'price': price,
    });

    _totalPrice += price;

    // Clear input fields
    bodyPartController.clear();
    treatmentController.clear();
    priceController.clear();

    notifyListeners();
  }

  Future<void> saveTreatmentPlan() async {
    try {
      await _treatmentPlanService.saveTreatmentPlan(_treatments); // Use the instance
      _treatments.clear();
      _totalPrice = 0.0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving treatment plan: $e');
    }
  }

  void removeTreatment(int index) {
    _totalPrice -= _treatments[index]['price'];
    _treatments.removeAt(index);
    notifyListeners();
  }
}
