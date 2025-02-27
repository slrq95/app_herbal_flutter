import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/appointement_services/appointment_view_service.dart';

class AppointmentViewProvider extends ChangeNotifier {
  final AppointmentViewService _service = AppointmentViewService();

  List<Map<String, dynamic>> _appointments = [];
  List<Map<String, dynamic>> get appointments => _appointments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

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

  // ✅ New function to update appointment status
  Future<void> updateAppointmentStatus(int appointmentId, String status) async {
    try {
      await _service.updateAppointmentStatus(appointmentId, status);

      // ✅ Update local state
      for (var appointment in _appointments) {
        if (appointment['id_appointment'] == appointmentId) {
          appointment['status'] = status;
          break;
        }
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}