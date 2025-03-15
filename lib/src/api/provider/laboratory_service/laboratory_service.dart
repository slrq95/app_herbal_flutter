import 'package:dio/dio.dart';

class LaboratoryService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:3000"));

  Future<Map<String, dynamic>?> addLaboratoryRecord({
    required int idPatient,
    required String laboratorist,
    required String piece,
    required double cost,
    required String createdAt,
  }) async {
    try {
      final response = await _dio.post(
        "/add_laboratory",
        data: {
          "id_patient": idPatient,
          "laboratorist": laboratorist,
          "piece":piece,
          "cost": cost,
          "created_at": createdAt,
        },
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print("Error adding laboratory record: $e");
      return null;
    }
  }
}
