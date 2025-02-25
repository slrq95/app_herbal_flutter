import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/treatment_plan_services/treatment_view_service.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/api/provider/treatment_plan_services/treatment_view_provider.dart';
import 'package:provider/provider.dart';
void showEditDialog(BuildContext context, Map<String, dynamic> treatment) {
  final TextEditingController treatmentController =
      TextEditingController(text: treatment['plan_treatment']);
  final TextEditingController bodyPartController =
      TextEditingController(text: treatment['body_part']);
  final TextEditingController priceController =
      TextEditingController(text: treatment['price'].toString());
  final TextEditingController binnacleController =
      TextEditingController(text: treatment['note']);

  final treatmentService = TreatmentViewService();
  final treatmentProvider = Provider.of<TreatmentViewProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: CustomTheme.fillColor,
        title: const Text("Editar Plan de Tratamiento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomInput(
              fillColor: CustomTheme.containerColor,
              iconColor: CustomTheme.buttonColor,
              borderColor: CustomTheme.containerColor,
              keyboardType: TextInputType.text,
              controller: treatmentController,
              labelText: "Tratamiento",
              hintText: "Ingrese tratamiento...",
              icon: Icons.medical_services,
            ),
            const SizedBox(height: 10),
            CustomInput(
              fillColor: CustomTheme.containerColor,
              iconColor: CustomTheme.buttonColor,
              borderColor: CustomTheme.containerColor,
              keyboardType: TextInputType.text,
              controller: bodyPartController,
              labelText: "Parte del cuerpo",
              hintText: "Ingrese parte del cuerpo...",
              icon: Icons.accessibility,
            ),
            const SizedBox(height: 10),
            CustomInput(
              fillColor: CustomTheme.containerColor,
              iconColor: CustomTheme.buttonColor,
              borderColor: CustomTheme.containerColor,
              keyboardType: TextInputType.number,
              controller: priceController,
              labelText: "Editar precio",
              hintText: "Ingrese precio",
              icon: Icons.attach_money,
            ),
            const SizedBox(height: 10),
            CustomInput(
              fillColor: CustomTheme.containerColor,
              iconColor: CustomTheme.buttonColor,
              borderColor: CustomTheme.containerColor,
              keyboardType: TextInputType.text,
              controller: binnacleController,
              labelText: "Notas",
              hintText: "Ingrese notas aquí...",
              icon: Icons.note,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await treatmentService.updateTreatmentPlan(
                  treatmentId: treatment['id_plan'],
                  planTreatment: treatmentController.text,
                  bodyPart: bodyPartController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  note: binnacleController.text,
                );

                // Refresh the UI after updating the treatment plan
                await treatmentProvider.fetchTreatmentViewPlans(treatment['id_patient']);

                // Show success message
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tratamiento actualizado correctamente'),
                  ),
                );

              } catch (e) {
                debugPrint("Error updating treatment plan: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al actualizar tratamiento'),
                  ),
                );
              }

              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      );
    },
  );
}