import 'package:dio/dio.dart';

class DioService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000', // Change to your server URL if hosted remotely
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<void> postPlanTratamiento(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/add_plan_tratamiento', data: data);
      print('Response: ${response.data}');
    } catch (e) {
      if (e is DioException) {
        // Handle DioError for better debugging
        print('DioError: ${e.response?.data ?? e.message}');
      } else {
        print('Error: $e');
      }
    }
  }
}
