import 'package:dio/dio.dart';

class AppointmentViewService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<List<Map<String, dynamic>>> getAppointmentsByDate(String date) async {
    try {
      final response = await _dio.get('/get_appointment', queryParameters: {'date': date});

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to fetch appointments');
      }
    } catch (e) {
      throw Exception('Error fetching appointments: $e');
    }
  }
    // ✅ New function to update appointment status
  Future<void> updateAppointmentStatus(int appointmentId, String status) async {
    try {
      await _dio.put(
        '/update_appointment/$appointmentId',
        data: {'status': status},
      );
    } catch (e) {
      throw Exception('Error updating appointment status: $e');
    }
  }
  
}
