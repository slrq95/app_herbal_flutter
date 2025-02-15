import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/models/patient_model.dart';
import 'package:app_herbal_flutter/dio/dio_get.dart';
import 'package:app_herbal_flutter/dio/dio_update.dart';
class PatientProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final DioGet dioGet = DioGet();
  final DioUpdate dioUpdate = DioUpdate(); // Add update instance

  final List<Patient> _patients = [
    Patient(id: 'id_patient', name: 'name', phone: 'phone', birthDate:'birth_date'),
  
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

      // Method to update a patient


    notifyListeners();
  }
    void forceNotify() {
    notifyListeners();
  }


}

class SelectedPatientProvider extends ChangeNotifier {
  Patient? _selectedPatient;
  Patient? _selectedId;

  Patient? get selectedPatient => _selectedPatient;
  Patient? get selectedId =>_selectedId;

void selectPatient(Patient patient, String id) { // ✅ Change `id` to String
  _selectedPatient = patient;
  notifyListeners();
}

}

class PatientUpdateProvider extends ChangeNotifier {
  final DioUpdate dioUpdate = DioUpdate();

  Future<bool> updatePatient(Patient patient, String newName, String newPhone, String newBirthDate) async {
    bool success = await dioUpdate.updatePatient(patient.id, newName, newPhone, newBirthDate );
    if (success) {
      patient.name = newName;
      patient.phone = newPhone;
      patient.birthDate = newBirthDate;

      notifyListeners();
    }
    return success;
  }
  
}
