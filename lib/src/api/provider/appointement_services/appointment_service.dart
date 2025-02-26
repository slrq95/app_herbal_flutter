import 'package:dio/dio.dart';
import 'package:app_herbal_flutter/src/models/appointment_model.dart';

class AppointmentService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Map<String, dynamic>> addAppointment(Appointment appointment) async {
    try {
      final response = await _dio.post(
        '/add_appointment',
        data: appointment.toJson(),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': response.data};
      } else {
        return {'success': false, 'error': 'Unexpected status code: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'};
    }
  }
}