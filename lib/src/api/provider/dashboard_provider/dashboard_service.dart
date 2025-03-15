import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DashboardService {
  final Dio _dio = Dio();
  final String baseUrl = "http://localhost:3000";

  Future<Map<String, dynamic>> fetchAppointmentStats({dynamic startDate, dynamic endDate}) async {
    try {
      final response = await _dio.get(
        "$baseUrl/get_appointment_stats_by_date",
        queryParameters: {
          "startDate": startDate ?? _defaultStartDate,
          "endDate": endDate ?? _defaultEndDate,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load appointment stats");
      }
    } catch (e) {
      debugPrint("Error fetching appointment stats: $e");
      return {"atendida": 0, "no_atendida": 0};
    }
  }

Future<double> fetchPaymentsByDate({dynamic startDate, dynamic endDate}) async {
  try {
    final response = await _dio.get(
      "$baseUrl/get_payments_by_date",
      queryParameters: {
        "startDate": startDate ?? _defaultStartDate,
        "endDate": endDate ?? _defaultEndDate,
      },
    );

    debugPrint("API Response: ${response.data}"); // Debugging line

    if (response.statusCode == 200) {
      final totalPayments = response.data["totalPayments"];
      double totalPaymentsDouble = 0;

      if (totalPayments is double) {
        //return totalPayments; // If it's already a double, return it directly
        totalPaymentsDouble = totalPayments;
      } else if (totalPayments is int) {
        totalPaymentsDouble = totalPayments.toDouble(); // Convert int to double
      } else if (totalPayments is String) {
        totalPaymentsDouble = double.tryParse(totalPayments) ?? 0.0; // Convert string to double safely
      }

      return totalPaymentsDouble;
    }

    throw Exception("Failed to load total payments");
  } catch (e) {
    debugPrint("Error fetching total payments: $e");
    return 0.0;
  }
}

Future<double> fetchTreatmentPricesByDate({dynamic startDate, dynamic endDate}) async {
  try {
    final response = await _dio.get(
      "$baseUrl/get_treatment_prices_by_date",
      queryParameters: {
        "startDate": startDate ?? _defaultStartDate,
        "endDate": endDate ?? _defaultEndDate,
      },
    );
    
    // Log the full response to check its structure
    debugPrint("Response data: ${response.data}");
    
    if (response.statusCode == 200) {
      final totalPrices = response.data["totalPrices"];
      
      // Try to convert the value to a double if it's not already
      if (totalPrices is String) {
        return double.tryParse(totalPrices) ?? 0.0;  // Safely parse String to double
      } else if (totalPrices is double) {
        return totalPrices;
      } else {
        return 0.0;  // Default fallback
      }
    } else {
      throw Exception("Failed to load treatment prices");
    }
  } catch (e) {
    debugPrint("Error fetching treatment prices: $e");
    return 0.0; // Default value
  }
}



  String get _defaultStartDate =>
      DateTime.now().subtract(const Duration(days: 30)).toIso8601String().split('T')[0];

  String get _defaultEndDate => DateTime.now().toIso8601String().split('T')[0];
}
