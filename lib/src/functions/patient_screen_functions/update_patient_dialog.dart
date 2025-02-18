  import 'package:flutter/material.dart';
  import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
  import 'package:app_herbal_flutter/src/models/patient_model.dart';
  
  void showEditDialog(BuildContext context, PatientUpdateProvider updateProvider, Patient patient) {
    TextEditingController nameController = TextEditingController(text: patient.name);
    TextEditingController phoneController = TextEditingController(text: patient.phone);
    TextEditingController birthDateController = TextEditingController(text: patient.birthDate);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Patient"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
            TextField(controller: birthDateController, decoration: const InputDecoration(labelText: "Birth Date")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              bool success = await updateProvider.updatePatient(
                patient,
                nameController.text,
                phoneController.text,
                birthDateController.text,
              );
              if (!context.mounted) return;
              if (success) Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }