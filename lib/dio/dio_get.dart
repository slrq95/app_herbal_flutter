import 'package:dio/dio.dart';

class DioGet {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://localhost:3000'), // Change to your server address
  );

  Future<List<Map<String, dynamic>>> fetchPatientByName(String name) async {
    try {
      final response = await _dio.get('/get_patient/$name');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load patient data');
      }
    } catch (e) {
      //print('Error fetching patient: $e');
      return [];
    }
  }
}
