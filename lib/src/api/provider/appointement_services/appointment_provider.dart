// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_herbal_flutter/src/models/appointment_model.dart';
import 'package:app_herbal_flutter/src/api/provider/appointement_services/appointment_service.dart';
import 'package:dio/dio.dart';
enum Priority { alta, media, baja }
enum TypeAppointment { consulta, reconsulta, procedimiento }
enum Status{atendida,noatendida}

  Priority selectedPrioridad = Priority.baja;
  TypeAppointment selectedTipoCita = TypeAppointment.consulta;
class AppointmentProvider extends ChangeNotifier {
    final Dio _dio = Dio();
  final String _baseUrl = "http://localhost:3000"; // Replace with your API URL

  TextEditingController reasonController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController reprogramDateController = TextEditingController();
  TextEditingController reprogramTimeController = TextEditingController();

  Priority selectedPrioridad = Priority.baja;
  TypeAppointment selectedTipoCita = TypeAppointment.consulta;

  Future<Map<String, dynamic>> addAppointment(Appointment appointment) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/add_appointment",
        data: appointment.toJson(),
      );

      if (response.statusCode == 201) {
        return {"success": true};
      } else {
        return {"success": false, "error": "Failed to create appointment"};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }


  final AppointmentService _appointmentService = AppointmentService();
    Future<void> saveAppointment(Appointment appointment) async {
    final response = await _appointmentService.addAppointment(appointment);
    if (response['success']) {
      // Handle success (e.g., show a message)
      debugPrint("Appointment saved successfully!");
    } else {
      // Handle error
      debugPrint("Error: ${response['error']}");
    }
  }


  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      notifyListeners(); // Notify UI of changes
    }
  }
  
  Future<void> selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      if (!context.mounted) return;
      controller.text = pickedTime.format(context);
      notifyListeners();
    }
  }

  void reprogramDateTime() {
    dateController.text = reprogramDateController.text;
    timeController.text = reprogramTimeController.text;
    notifyListeners();
  }
    // Selected values



  // Setters
  void setPrioridad(Priority priority) {
    selectedPrioridad = priority;
    notifyListeners();
  }

  void setTipoCita(TypeAppointment typeAppointment) {
    selectedTipoCita = typeAppointment;
    notifyListeners();
  }
}

