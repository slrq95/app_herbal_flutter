import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000', // Change if using a remote server
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  // ✅ Function to send patient data
  Future<Response?> postPatient(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/add_patient', data: data);
      debugPrint('Response: ${response.data}');
      return response; // Return the response object
    } on DioException catch (e) {
      debugPrint('DioError: ${e.response?.data ?? e.message}');
      return e.response; // Return the response to handle errors properly
    } catch (e) {
      debugPrint('Error: $e');
      return null; // Return null for unexpected errors
    }
  }
    // New method to post clinical history
  Future<Response?> postClinicalHistory(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/add_clinical_history', data: data);
      debugPrint('Response: ${response.data}');
      return response;
    } on DioException catch (e) {
      debugPrint('DioError: ${e.response?.data ?? e.message}');
      return e.response;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }
}

