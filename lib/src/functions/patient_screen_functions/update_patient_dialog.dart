import 'package:app_herbal_flutter/src/theme/default.dart';
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
                    bool success = await updateProvider.updatePatient(
                      patient,
                      nameController.text,
                      phoneController.text,
                      birthDateController.text,
                      patientProvider,
                    );
                    if (!context.mounted) return;
                    if (success) Navigator.pop(context);
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
