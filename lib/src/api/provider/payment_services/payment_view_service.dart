import 'package:dio/dio.dart';

class ViewPaymentService {
  final Dio _dio = Dio(
     BaseOptions(
      baseUrl: "http://localhost:3000", // Replace with your backend URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<dynamic>> fetchPayments(String patientId) async {
    try {
      final response = await _dio.get('/get_payments/$patientId');

      if (response.statusCode == 200) {
        return response.data; // Returns the list of payments
      } else {
        throw Exception("Failed to fetch payments");
      }
    } catch (error) {
      throw Exception("Error fetching payments: $error");
    }
  }
}
