import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController birthDateController = TextEditingController();
void showPatientDialog(BuildContext context) {
  String timestamp = DateTime.now().toLocal().toString();

  showDialog(
    context: (context),
    builder: (context) => AlertDialog(
      backgroundColor: CustomTheme.containerColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero, // Remove default padding
      title: const Text(
        'Ingresar Paciente',
        style: TextStyle(color: CustomTheme.lettersColor, fontSize: 28), // Title font size
      ),
      
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8, // 80% width of screen
        height: MediaQuery.of(context).size.height * 0.6, // 60% height of screen
        child: SingleChildScrollView( // Ensure the content is scrollable
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20.0),
              CustomInput(
                controller: nameController,
                keyboardType: TextInputType.name,
                labelText: 'Nombre',
                hintText: 'Ingrese nombre',
                icon: Icons.person,
                borderColor: CustomTheme.primaryColor,
                iconColor: CustomTheme.onprimaryColor,
                fillColor: Colors.grey[800]!,
                labelStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Label font size
                hintStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Hint font size
                inputStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Input text font size
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                labelText: 'Teléfono',
                hintText: 'Ingrese teléfono',
                icon: Icons.phone,
                borderColor: CustomTheme.primaryColor,
                iconColor: CustomTheme.onprimaryColor,
                fillColor: Colors.grey[800]!,
                labelStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Label font size
                hintStyle: const TextStyle(fontSize: 32, color:CustomTheme.lettersColor ), // Hint font size
                inputStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Input text font size
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: birthDateController,
                keyboardType: TextInputType.datetime,
                labelText: 'Fecha de Nacimiento',
                hintText: 'YYYY-MM-DD',
                icon: Icons.calendar_today,
                borderColor: CustomTheme.primaryColor,
                iconColor: CustomTheme.onprimaryColor,
                fillColor: Colors.grey[800]!,
                labelStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Label font size
                hintStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Hint font size
                inputStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Input text font size
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: TextEditingController(text: timestamp),
                keyboardType: TextInputType.text,
                labelText: 'Timestamp',
                hintText: timestamp,
                icon: Icons.access_time,
                borderColor: CustomTheme.primaryColor,
                iconColor: CustomTheme.onprimaryColor,
                fillColor: Colors.grey[800]!,
                labelStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Label font size
                hintStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Hint font size
                inputStyle: const TextStyle(fontSize: 32, color: CustomTheme.lettersColor), // Input text font size
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
          onPressed: () {
            // Save logic
            print('Paciente agregado: ${nameController.text}');
            Navigator.pop(context);
          },
          child: const Text('Guardar', style: TextStyle(color: CustomTheme.primaryColor, fontSize: 28)),
        ),
      ],
    ),
  );
}