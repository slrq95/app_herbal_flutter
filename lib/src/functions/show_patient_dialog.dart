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
  Map<String, dynamic> patientData = {
    'name': nameController.text,
    'phone': phoneController.text,
    'birth_date': birthDateController.text,
    'timestamp_patient_creation': timestamp,
  };

  try {
    final response = await DioService().postPatient(patientData);
<<<<<<< HEAD

=======
    if (!context.mounted) return;
>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)
    if (response?.statusCode == 201) {
      Navigator.pop(context);
      showMessage(context, 'Paciente agregado exitosamente');
    }
  } catch (e) {
    if (e is DioException) {
      String errorMessage = 'Error al agregar el paciente';

      if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;

        if (data is Map<String, dynamic> && data.containsKey('error')) {
          errorMessage = data['error']; // Extract the backend error message
        }
      }
<<<<<<< HEAD

      showMessage(context, errorMessage);
    } else {
=======
      if (!context.mounted) return;
      showMessage(context, errorMessage);
    } else {
      if (!context.mounted) return;
>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)
      showMessage(context, 'Error desconocido');
    }
  }
},


          child: const Text('Guardar', style: TextStyle(color: CustomTheme.primaryColor, fontSize: 28)),
        ),
      ],
    ),
  );
}

/// ✅ Function to show an alert dialog
void showMessage(BuildContext context, String message) {
  Future.delayed(Duration.zero, () {
<<<<<<< HEAD
    showDialog(
=======
    if (!context.mounted) return;
    showDialog(
      
>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)
      context: context,
      barrierDismissible: false, // Prevent accidental dismiss
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: CustomTheme.containerColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Información',
            style: TextStyle(color: CustomTheme.lettersColor, fontSize: 24),
          ),
          content: Text(
            message,
            style: const TextStyle(color: CustomTheme.lettersColor, fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK', style: TextStyle(color: CustomTheme.primaryColor, fontSize: 24)),
            ),
          ],
        );
      },
    );
  });
}
