import 'dart:convert';

import 'package:app_herbal_flutter/src/tools/show_error.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/dio/dio_post.dart'; // Import Dio service
import 'package:dio/dio.dart';
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController birthDateController = TextEditingController();

void showPatientDialog(BuildContext context) {
  String timestamp = DateTime.now().toLocal().toString();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: CustomTheme.containerColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Ingresar Paciente',
        style: TextStyle(color: CustomTheme.lettersColor, fontSize: 28),
      ),
      
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInput(
                controller: nameController,
                keyboardType: TextInputType.name,
                labelText: 'Nombre',
                hintText: 'Ingrese nombre',
                icon: Icons.person,
                borderColor: CustomTheme.primaryColor,
                iconColor: CustomTheme.onprimaryColor,
                fillColor: Colors.grey[800]!,
              ),
              CustomInput(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                labelText: 'Teléfono',
                hintText: 'Ingrese teléfono',
                icon: Icons.phone,
                borderColor: CustomTheme.primaryColor,
                iconColor: CustomTheme.onprimaryColor,
                fillColor: Colors.grey[800]!,
              ),
              CustomInput(
                controller: birthDateController,
                keyboardType: TextInputType.datetime,
                labelText: 'Fecha de Nacimiento',
                hintText: 'YYYY-MM-DD',
                icon: Icons.calendar_today,
                borderColor: CustomTheme.primaryColor,
                iconColor: CustomTheme.onprimaryColor,
                fillColor: Colors.grey[800]!,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: CustomTheme.secondaryColor, fontSize: 28)),
        ),
        TextButton(
          onPressed: () async {
            String name = nameController.text.trim();
            String phone = phoneController.text.trim();
            String birthDate = birthDateController.text.trim();

            // Name validation: Only letters and spaces allowed
            RegExp namePattern = RegExp(r"^[a-zA-ZÀ-ÿ\s]+$");
            if (name.isEmpty || !namePattern.hasMatch(name)) {
              showErrorDialog(context, 'Nombre Invalido. Solo letras y espacios estan permitidos.');
                  // Phone validation: Only numbers and spaces allowed
          
              return;
            }

            RegExp phonePattern = RegExp(r"^[0-9\s]+$");
            if (phone.isEmpty || !phonePattern.hasMatch(phone)) {
              showErrorDialog(context, 'Número de teléfono inválido. Solo números y espacios están permitidos.');
              return;
            }
            // Regex to validate date format YYYY-MM-DD
            RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
            if (!datePattern.hasMatch(birthDate)) {
              showErrorDialog(context, 'Formato invalido. Debe de usar AÑO-Mes-Dia');
              return;
            }

            try {
              List<String> parts = birthDate.split("-");
              int year = int.parse(parts[0]);
              int month = int.parse(parts[1]);
              int day = int.parse(parts[2]);

              if (year < 1900) {
                showErrorDialog(context, "La fecha de nacimiento no puede ser antes de 1900.");
                return;
              }

              if (month < 1 || month > 12) {
                showErrorDialog(context, "Mes invalido. Debe de estar entre 1 y 12.");
                return;
              }

              int maxDays = DateTime(year, month + 1, 0).day;
              if (day < 1 || day > maxDays) {
                showErrorDialog(context, "Dia invalido. el mes $month tiene solo $maxDays dias.");
                return;
              }

              Map<String, dynamic> patientData = {
                'name': name,
                'phone': phone,
                'birth_date': birthDate,
                'created_at': timestamp,
              };

              final response = await DioService().postPatient(patientData);

              if (!context.mounted) return;

              if (response?.statusCode == 201) {
                Navigator.pop(context);
                showErrorDialog(context, 'Paciente agregado exitosamente');
                nameController.clear();
                phoneController.clear();
                birthDateController.clear();
              }
            }
            
        catch (e, stackTrace) { // Capture stack trace for debugging
          debugPrint("🚨 CATCH BLOCK TRIGGERED 🚨");
          debugPrint("Error Type: ${e.runtimeType}"); // Print actual type of exception
          debugPrint("Stack Trace: $stackTrace");

          String errorMessage = 'Error al agregar el paciente';

          if (e is DioException) { // Ensure it’s catching DioException
            debugPrint("✅ DioException caught!");
            debugPrint("Type: ${e.type}");
            debugPrint("Message: ${e.message}");
            debugPrint("Response Status Code: ${e.response?.statusCode}");
            debugPrint("Full Response: ${e.response}");
            debugPrint("Response Data: ${e.response?.data}");
            debugPrint("Response Data Type: ${e.response?.data.runtimeType}");

            if (e.response != null) {
              final data = e.response!.data;

              // CASE 1: If the response is already a Map, extract the error message
              if (data is Map<String, dynamic>) {
                errorMessage = data['error'] ?? 'Unknown error occurred.';
              }
              // CASE 2: If the response is a String, attempt to parse it
              else if (data is String) {
                try {
                  final parsedData = jsonDecode(data);
                  if (parsedData is Map<String, dynamic> && parsedData.containsKey('error')) {
                    errorMessage = parsedData['error'];
                  } else {
                    errorMessage = data; // Use raw message if JSON parsing fails
                  }
                } catch (_) {
                  errorMessage = data; // Use raw message if parsing fails
                }
              }
              // CASE 3: Unexpected response format
              else {
                errorMessage = 'Unknown error format: ${data.toString()}';
              }
            } else {
              errorMessage = 'No response from server.';
            }
          } else {
            debugPrint("🚨 Unexpected error: $e");
            errorMessage = "Unexpected error occurred: $e";
          }

          if (!context.mounted) return;

          Future.delayed(Duration(milliseconds: 100), () {
          if (context.mounted) {
            debugPrint("Showing Error Dialog: $errorMessage"); // Debug log
            showErrorDialog(context, errorMessage); // Ensure this is executed
          }
          });
        }
          },
          child: const Text(
            'Guardar',
            style: TextStyle(color: CustomTheme.primaryColor, fontSize: 28),
          ),
        ),
      ],
    ),
  );
}
