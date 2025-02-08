import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';


class ClinicalHistoryPage extends StatelessWidget {
  ClinicalHistoryPage({super.key});

  final TextEditingController nameController = TextEditingController(text: "Nombre del Paciente");
  final TextEditingController historiaClinicaController = TextEditingController();
  final TextEditingController caracteristicasPacienteController = TextEditingController();
  final TextEditingController motivoConsultaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.fillColor, // Dark background color
      body: Column(
        children: [
          // Custom container instead of AppBar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: CustomTheme.containerColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Historia Clínica',
                  style: TextStyle(
                    color: CustomTheme.lettersColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomButton(
                  text: 'Regresar',
                  width: 120,
                  height: 50,
                  color: CustomTheme.fillColor,
                  style: const TextStyle(
                    color: CustomTheme.lettersColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Form fields inside a scrollable SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Non-editable Patient Name input field
                  Container(
                    width: double.infinity,
                    height: 70.0,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                    color: CustomTheme.containerColor, // Background color
                    borderRadius: BorderRadius.circular(10),
                      ),
                    child: Row(
                      children: [
                      const Icon(Icons.person, color: Colors.white), // User icon
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                        nameController.text.isNotEmpty 
                        ? nameController.text // Display patient name if available
                        : 'Cargando...', // Placeholder while fetching data
                        style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                          ),
                        overflow: TextOverflow.ellipsis, // Handles long names
                      ),
                    ),
                    ],
                  ),
                ),

                  const SizedBox(height: 20),

                  // Historia Clínica input field
                  CustomInput(
                    controller: historiaClinicaController,
                    keyboardType: TextInputType.text,
                    labelText: 'Historia Clínica',
                    hintText: 'Ingrese la historia clínica del paciente',
                    icon: Icons.history,
                    borderColor: Colors.transparent,
                    iconColor: Colors.white,
                    fillColor: CustomTheme.containerColor,
                    fontSize: 22,
                  ),

                  const SizedBox(height: 20),

                  // Características del Paciente input field
                  CustomInput(
                    controller: caracteristicasPacienteController,
                    keyboardType: TextInputType.text,
                    labelText: 'Características del Paciente',
                    hintText: 'Describa las características del paciente',
                    icon: Icons.info,
                    borderColor: Colors.transparent,
                    iconColor: Colors.white,
                    fillColor: CustomTheme.containerColor,
                    fontSize: 22,
                  ),

                  const SizedBox(height: 20),

                  // Motivo de la Consulta input field
                  CustomInput(
                    controller: motivoConsultaController,
                    keyboardType: TextInputType.text,
                    labelText: 'Motivo de la Consulta',
                    hintText: 'Explique el motivo de la consulta',
                    icon: Icons.note_add,
                    borderColor: Colors.transparent,
                    iconColor: Colors.white,
                    fillColor: CustomTheme.containerColor,
                    fontSize: 22,
                  ),

                  const SizedBox(height: 30),

                  // Custom Submit Button
                  CustomButton(
                    text: 'Guardar Datos',
                    width: 250,
                    height: 70,
                    color: CustomTheme.buttonColor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    onPressed: () {
                      // Handle form submission here
                    },
                  ),

                  const SizedBox(height: 50), // Extra spacing at the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
