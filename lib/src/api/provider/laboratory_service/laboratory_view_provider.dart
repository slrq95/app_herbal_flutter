import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/laboratory_service/laboratory_view_service.dart';
import 'package:dio/dio.dart';
class LaboratoryViewProvider with ChangeNotifier {
  final LaboratoryViewService _laboratoryViewService = LaboratoryViewService();

  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _laboratoryData = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get laboratoryData => _laboratoryData;

Future<void> fetchLaboratoryData(int idPatient) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final data = await _laboratoryViewService.getLaboratoryData(idPatient);

    if (data.isNotEmpty) {
      _laboratoryData = data;
    } else {
      _errorMessage = "No laboratory data found for this patient.";
    }
  } catch (e) {
    // Handle DioException
    if (e is DioException) {
      if (e.response?.statusCode == 404) {
        _errorMessage = "No laboratory data found for this patient.";
      } else {
        _errorMessage = "An error occurred while fetching data.";
      }
    } else {
      _errorMessage = "An unexpected error occurred.";
    }
  }

  _isLoading = false;
  notifyListeners();
}
}
