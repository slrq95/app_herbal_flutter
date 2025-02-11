import 'package:flutter/material.dart';

class TreatmentPlanProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController(text: 'Nombre del Paciente');
  final TextEditingController bodyPartController = TextEditingController();
  final TextEditingController treatmentController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  
  final List<Map<String, dynamic>> _treatments = [];
  double _totalPrice = 0.0;

  List<Map<String, dynamic>> get treatments => _treatments;
  double get totalPrice => _totalPrice;

  void addTreatment() {
    if (bodyPartController.text.isNotEmpty &&
        treatmentController.text.isNotEmpty &&
        priceController.text.isNotEmpty) {
      double price = double.tryParse(priceController.text) ?? 0.0;
      
      _treatments.add({
        'name': nameController.text,
        'bodyPart': bodyPartController.text,
        'treatment': treatmentController.text,
        'price': price,
      });

      _totalPrice += price;

      bodyPartController.clear();
      treatmentController.clear();
      priceController.clear();

      notifyListeners();
    }
  }
void removeTreatment(int index) {
  _treatments.removeAt(index);
  _totalPrice = _treatments.fold(0.0, (sum, item) => sum + item['price']);  // Recalculate total price
  notifyListeners();  // Notify the UI about the change
}
}
