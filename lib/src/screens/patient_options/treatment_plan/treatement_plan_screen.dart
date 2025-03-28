import 'package:app_herbal_flutter/src/functions/treatment_plan_functions/show_cancel.dart';
import 'package:app_herbal_flutter/src/tools/show_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/components/custom_card.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/api/provider/treatment_plan_services/treatment_plan_provider.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
  final TextEditingController nameController = TextEditingController(text: 'Nombre del Paciente');
class TreatmentPlanScreen extends StatefulWidget {
  const TreatmentPlanScreen({super.key});

  @override
  TreatmentPlanScreenState createState() => TreatmentPlanScreenState();
}

class TreatmentPlanScreenState extends State<TreatmentPlanScreen> {

  @override
  Widget build(BuildContext context) {
    final treatmentProvider = Provider.of<TreatmentPlanProvider>(context, listen: false);
    final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
    final patient = selectedPatientProvider.selectedPatient;

    if (patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(
          child: Text("No se proporcionaron datos del paciente"),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.fillColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: CustomTheme.containerColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Plan de tratamientos',
                        style: TextStyle(color: CustomTheme.lettersColor, fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      CustomButton(
                        text: 'Regresar',
                        width: 120,
                        height: 50,
                        color: CustomTheme.fillColor,
                        onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),                
                  CustomButton(
                    borderColor: Colors.amber,
                  text: 'Visualizar Planes de Tratamiento',
                  width: 200,
                  height: 70,
                  color: CustomTheme.tertiaryColor,
onPressed: () {
  // Get the selected patient provider
  final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
  
  // Set the selected patient
  selectedPatientProvider.selectPatient(patient, patient.id);
  
  // Navigate to TreatmentPlanView with the correct patient ID
  Navigator.pushNamed(
    context,
    '/TreatmentPlanView',
    arguments: {'patientId': patient.id}, // Use patient.id instead of selectedPatient.id
  );
},
                ),
                const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
              
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomTheme.containerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            patient.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
              
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomTheme.containerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.perm_identity_rounded, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            patient.id,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Input fields and Add Plan Button
                CustomInput(
                  controller: treatmentProvider.bodyPartController,
                  keyboardType: TextInputType.text,
                  labelText: 'Parte del Cuerpo',
                  hintText: 'Ej: Espalda',
                  icon: Icons.accessibility,
                  borderColor: Colors.grey,
                  iconColor: CustomTheme.lettersColor,
                  fillColor: CustomTheme.containerColor,
                ),
                CustomInput(
                  controller: treatmentProvider.treatmentController,
                  keyboardType: TextInputType.text,
                  labelText: 'Tratamiento a Seguir',
                  hintText: 'Ej: Masaje',
                  icon: Icons.spa,
                  borderColor: Colors.grey,
                  iconColor: CustomTheme.lettersColor,
                  fillColor: CustomTheme.containerColor,
                ),
                CustomInput(
                  controller: treatmentProvider.priceController,
                  keyboardType: TextInputType.number,
                  labelText: 'Precio del Tratamiento',
                  hintText: 'Ej: 50.0',
                  icon: Icons.attach_money,
                  borderColor: Colors.grey,
                  iconColor: CustomTheme.lettersColor,
                  fillColor: CustomTheme.containerColor,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  height: 70,
                  borderColor: Colors.green,
                  color: CustomTheme.primaryColor,
                  text: 'Agregar Plan',
                  onPressed: () {
                    // Get the input values
                    String bodyPart = treatmentProvider.bodyPartController.text.trim();
                    String treatment = treatmentProvider.treatmentController.text.trim();
                    String price = treatmentProvider.priceController.text.trim();

                    // Define regex patterns
                    RegExp validText = RegExp(r"^[a-zA-Z0-9\s]+$"); // Letters, numbers, and spaces only
                    RegExp validPrice = RegExp(r"^\d+(\.\d{1,2})?$"); // Only numbers (integer or decimal)

                    // Validate inputs
                    if (bodyPart.isEmpty || treatment.isEmpty || price.isEmpty) {
                      showErrorDialog(context, "Todos los campos son obligatorios.");
                      return;
                    }
                    if (!validText.hasMatch(bodyPart)) {
                      showErrorDialog(context, "La 'Parte del Cuerpo' solo puede contener letras, números y espacios.");
                      return;
                    }
                    if (!validText.hasMatch(treatment)) {
                      showErrorDialog(context, "El 'Tratamiento' solo puede contener letras, números y espacios.");
                      return;
                    }
                    if (!validPrice.hasMatch(price)) {
                      showErrorDialog(context, "El 'Precio' debe ser un número válido.");
                      return;
                    }

                    // If all validations pass, add the treatment
                    treatmentProvider.addTreatment(patient.id);
                  },
                ),

                const SizedBox(height: 20),

                // List of Treatment Cards
                Consumer<TreatmentPlanProvider>(
                  builder: (context, provider, child) {
                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.treatments.length,
                        itemBuilder: (context, index) {
                        final treatment = provider.treatments[index];
                        return CustomCard(
                          height: 205,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                    const Divider(color: Colors.white24, thickness: 1), // Optional divider
                                    Row(
                                      children: [
                                        const Icon(Icons.person, color: Colors.white),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'id: ${treatment['id_patient']}',
                                            style: const TextStyle(fontSize: 16, color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Row for Body Part
                                    Row(
                                      children: [
                                        const Icon(Icons.accessibility, color: Colors.white),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Parte del Cuerpo: ${treatment['bodyPart']}',
                                            style: const TextStyle(fontSize: 16, color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(color: Colors.white24, thickness: 1), 

                                    // Row for Treatment
                                    Row(
                                      children: [
                                        const Icon(Icons.spa, color: Colors.white),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Tratamiento: ${treatment['treatment']}',
                                            style: const TextStyle(fontSize: 16, color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const Divider(color: Colors.white24, thickness: 1), 

                                    // Row for Price & Delete Button
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.attach_money, color: Colors.green),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Precio: \$${treatment['price']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.cancel, color: Colors.red),
                                          onPressed: () {
                                            showCancelConfirmationDialog(context, index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          // Total Price Card
                          CustomCard(
                            child: Text(
                              'Total: \$${provider.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Save Button
CustomButton(
  height: 70,
  text: 'Guardar Datos',
  onPressed: () async {
    await treatmentProvider.saveTreatmentPlan();  // Call the method to save the treatment plan
  },
),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}