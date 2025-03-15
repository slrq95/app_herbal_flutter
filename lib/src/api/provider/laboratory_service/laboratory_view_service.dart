import 'package:dio/dio.dart';

class LaboratoryViewService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:3000"));

  Future<List<Map<String, dynamic>>> getLaboratoryData(int idPatient) async {
    try {
      final response = await _dio.get('/get_laboratory/$idPatient');
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching laboratory data: $e");
      return [];
    }
  }
}
