import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/models/patient_model.dart';
import 'package:app_herbal_flutter/dio/dio_get.dart';

class PatientProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final DioGet dioGet = DioGet();

  final List<Patient> _patients = [
    Patient(id: 'id_patient', name: 'name', phone: 'phone', birthDate:'birth_date' ),
  
  ];

  List<Patient> _filteredPatients = [];

  List<Patient> get filteredPatients => _filteredPatients;

  PatientProvider() {
    _filteredPatients = _patients;
  }

  Future<void> filterPatients(String query) async {
    if (query.isEmpty) {
      _filteredPatients = [];
    } else {
      final fetchedPatients = await dioGet.fetchPatientByName(query);
      
      _filteredPatients = fetchedPatients.map((json) => Patient.fromJson(json)).toList();
    }

    notifyListeners();
  }
}

class SelectedPatientProvider extends ChangeNotifier {
  Patient? _selectedPatient;

  Patient? get selectedPatient => _selectedPatient;

  void selectPatient(Patient patient) {
    _selectedPatient = patient;
    notifyListeners();
  }


}