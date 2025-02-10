import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/models/patient_model.dart';

class PatientProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  final List<Patient> _patients = [
    Patient(id: '123', name: 'Juan Pérez', diagnosis: 'Caries'),
  
  ];

  List<Patient> _filteredPatients = [];

  List<Patient> get filteredPatients => _filteredPatients;

  PatientProvider() {
    _filteredPatients = _patients;
  }

  void filterPatients(String query) {
    if (query.isEmpty) {
      _filteredPatients = _patients;
    } else {
      _filteredPatients = _patients
          .where((patient) =>
              patient.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
