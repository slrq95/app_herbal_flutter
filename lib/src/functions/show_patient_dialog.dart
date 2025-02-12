import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/dio/dio_post.dart'; // Import Dio service

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
            // ✅ Prepare patient data
            Map<String, dynamic> patientData = {
              'name': nameController.text,
              'phone': phoneController.text,
              'birth_date': birthDateController.text,
              'timestamp_patient_creation': timestamp,
            };

            // ✅ Send to API
            await DioService().postPatient(patientData);

            Navigator.pop(context);
          },
          child: const Text('Guardar', style: TextStyle(color: CustomTheme.primaryColor, fontSize: 28)),
        ),
      ],
    ),
  );
}
