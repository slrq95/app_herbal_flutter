import 'package:dio/dio.dart';
<<<<<<< HEAD
=======
import 'package:flutter/foundation.dart';
>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)

class DioUpdate {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://localhost:3000'),
  );

  // Updated method with correct URL and return type.
  Future<bool> updatePatient(dynamic id, String name, String phone, String birthDate) async {
    try {
      // Correct string interpolation for the URL.
      Response response = await _dio.put(
        '/update_patient/$id',  // Use $id directly here
        data: {
          "name": name,
          "phone": phone,
          "birth_date": birthDate,
        },
      );

      // Check if status code is 200 and return a boolean value.
      return response.statusCode == 200;
    } catch (e) {
<<<<<<< HEAD
      print("Error updating patient: $e");
=======
      debugPrint("Error updating patient: $e");
>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)
      return false;
    }
  }
}