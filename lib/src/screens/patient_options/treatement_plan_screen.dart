import 'package:app_herbal_flutter/src/functions/treatment_plan_functions/show_cancel.dart';
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
    final treatmentProvider = Provider.of<TreatmentPlanProvider>(context);
    final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context);
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
                        style: TextStyle(color: CustomTheme.lettersColor, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      CustomButton(
                        text: 'Regresar',
                        width: 100,
                        height: 40,
                        color: CustomTheme.fillColor,
                        onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),                
                  CustomButton(
                  text: 'Visualizar Planes de Tratamiento',
                  width: 200,
                  color: CustomTheme.tertiaryColor,
                  onPressed: () {
                    // Add your navigation or functionality here
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
                  color: CustomTheme.primaryColor,
                  text: 'Agregar Plan',
                  onPressed: treatmentProvider.addTreatment,
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
                              // Row for Patient Name
                                Row(
                                  children: [
                                    const Icon(Icons.person, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Paciente: ${nameController.text}',
                                        style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                    const Divider(color: Colors.white24, thickness: 1), // Optional divider

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
                            text: 'Guardar Datos',
                            onPressed: () {},
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
