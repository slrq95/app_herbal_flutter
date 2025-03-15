import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/laboratory_service/laboratory_service.dart';

class LaboratoryProvider with ChangeNotifier {
  final LaboratoryService _laboratoryService = LaboratoryService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> addLaboratoryRecord({
    required int idPatient,
    required String laboratorist,
    required String piece,
    required double cost,
    required String createdAt,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _laboratoryService.addLaboratoryRecord(
      idPatient: idPatient,
      laboratorist: laboratorist,
      piece: piece,
      cost: cost,
      createdAt: createdAt,
    );

    _isLoading = false;

    if (response != null) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = "Failed to add laboratory record.";
      notifyListeners();
      return false;
    }
  }
}
