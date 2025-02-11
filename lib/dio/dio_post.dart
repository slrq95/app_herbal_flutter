import 'package:dio/dio.dart';

class DioService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000', // Change if using a remote server
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  // ✅ Function to send patient data
  Future<void> postPatient(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/add_patient', data: data);
      print('Response: ${response.data}');
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.response?.data ?? e.message}');
      } else {
        print('Error: $e');
      }
    }
  }
}
