import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/tools/show_error.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:app_herbal_flutter/src/models/patient_model.dart';

void showEditDialog(BuildContext context, PatientUpdateProvider updateProvider,
    PatientProvider patientProvider, Patient patient) {
  TextEditingController nameController =
      TextEditingController(text: patient.name);
  TextEditingController phoneController =
      TextEditingController(text: patient.phone);
  TextEditingController birthDateController =
      TextEditingController(text: patient.birthDate);

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CustomTheme.fillColor, // Dark background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Edit Patient",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for contrast
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Phone",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: birthDateController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Birth Date",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  
                  style: TextButton.styleFrom(
                    backgroundColor: CustomTheme.containerColor,
                    foregroundColor: Colors.white.withOpacity(0.8)
                    ,
                  ),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String name = nameController.text.trim();
                      String birthDateText = birthDateController.text;
                      String phone = phoneController.text.trim();
                      RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

                          // Name validation: Only letters and spaces allowed
                    RegExp namePattern = RegExp(r"^[a-zA-ZÀ-ÿ\s]+$");
                    if (name.isEmpty || !namePattern.hasMatch(name)) {
                      showErrorDialog(context, 'Nombre Invalido. Solo letras y espacios estan permitidos.');
                      return;
                    }

                          // Phone validation: Only digits and spaces allowed
                      RegExp phonePattern = RegExp(r'^[0-9\s]+$');
                      if (phone.isEmpty || !phonePattern.hasMatch(phone)) {
                        showErrorDialog(context, "Numero Invalido. Solo numeros y espacios están permitidos.");
                        return;
                      }

                      if (!datePattern.hasMatch(birthDateText)) {
                        showErrorDialog(context, "Formato Invalido. siga el siguiente Año-Mes-Dia(AAAA/MM/DD).");
                        return;
                      }

                      List<String> parts = birthDateText.split("-");
                      int year = int.parse(parts[0]);
                      int month = int.parse(parts[1]);
                      int day = int.parse(parts[2]);

                      // Validate Year
                      if (year < 1900) {
                        showErrorDialog(context, "La fecha de nacimiento no puede ser antes de 1900.");
                        return;
                      }

                      // Validate Month (1-12)
                      if (month < 1 || month > 12) {
                        showErrorDialog(context, "Mes invalido. Debe de estar entre 1 y 12.");
                        return;
                      }

                      // Validate Day (Valid for the given month and year)
                      int maxDays = DateTime(year, month + 1, 0).day; // Last day of the month
                      if (day < 1 || day > maxDays) {
                        showErrorDialog(
                          context,
                          "Dia Invalido. El mes $month solo tiene $maxDays dias."
                        );
                        return;
                      }

                      // If all validations pass, create DateTime object
                      

                      bool success = await updateProvider.updatePatient(
                        patient,
                        nameController.text,
                        phoneController.text,
                        birthDateController.text,
                        patientProvider,
                      );

                      if (!context.mounted) return;
                      if (success) Navigator.pop(context);
                    } catch (e) {
                      showErrorDialog(context, "Error processing the birth date. Please enter a valid date (YYYY-MM-DD).");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomTheme.buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Guardar"),
                ),


              ],
            ),
          ],
        ),
      ),
    ),
  );
}
