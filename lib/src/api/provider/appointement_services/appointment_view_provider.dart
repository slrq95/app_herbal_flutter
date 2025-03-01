  import 'package:flutter/material.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:app_herbal_flutter/src/api/provider/appointement_services/appointment_view_service.dart';

  class AppointmentViewProvider extends ChangeNotifier {
    final AppointmentViewService _service = AppointmentViewService();
    
    List<Map<String, dynamic>> _appointments = [];
    List<Map<String, dynamic>> get appointments => _appointments;

    bool _isLoading = false;
    bool get isLoading => _isLoading;

    String? _errorMessage;
    String? get errorMessage => _errorMessage;

    Set<int> _updatedAppointments = {};  // Store updated appointment IDs
    Set<int> get updatedAppointments => _updatedAppointments;

    AppointmentViewProvider() {
      _loadUpdatedAppointments();  // Load stored updated appointments
    }

    Future<void> fetchAppointmentsByDate(String date) async {
      try {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();

        _appointments = await _service.getAppointmentsByDate(date);

      } catch (e) {
        _errorMessage = e.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }

    // ✅ Function to update appointment status and save state
    Future<void> updateAppointmentStatus(int appointmentId, String status) async {
      try {
        await _service.updateAppointmentStatus(appointmentId, status);

        for (var appointment in _appointments) {
          if (appointment['id_appointment'] == appointmentId) {
            appointment['status'] = status;
            break;
          }
        }

        _updatedAppointments.add(appointmentId);
        await _saveUpdatedAppointments();  // Save updated appointments in SharedPreferences
        notifyListeners();

      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
      }
    }

    // ✅ Save updated appointments to SharedPreferences
    Future<void> _saveUpdatedAppointments() async {
      final prefs = await SharedPreferences.getInstance();
      final updatedList = _updatedAppointments.map((id) => id.toString()).toList();
      await prefs.setStringList('updatedAppointments', updatedList);
    }

    // ✅ Load updated appointments from SharedPreferences
    Future<void> _loadUpdatedAppointments() async {
      final prefs = await SharedPreferences.getInstance();
      final storedList = prefs.getStringList('updatedAppointments') ?? [];
      _updatedAppointments = storedList.map((id) => int.parse(id)).toSet();
      notifyListeners();
    }
  Future<void> rescheduleAppointment(int appointmentId, String date, String time) async {
    try {
      await _service.rescheduleAppointment(appointmentId, date, time);

      // Update the local list of appointments
      for (var appointment in _appointments) {
        if (appointment['id_appointment'] == appointmentId) {
          appointment['date'] = date;
          appointment['time'] = time;
          break;
        }
      
      }
      await fetchAppointmentsByDate(date);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      throw Exception("Error rescheduling appointment: $e");
    }
  }
void removeAppointmentFromList(int appointmentId) {
  appointments.removeWhere((appointment) => appointment['id_appointment'] == appointmentId);
  notifyListeners();  // Update UI
}


  }