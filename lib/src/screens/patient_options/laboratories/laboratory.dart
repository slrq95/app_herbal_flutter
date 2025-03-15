import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/provider/laboratory_service/laboratory_provider.dart';

class LaboratoryScreen extends StatefulWidget {
  const LaboratoryScreen({super.key});

  @override
  LaboratoryScreenState createState() => LaboratoryScreenState();
}

class LaboratoryScreenState extends State<LaboratoryScreen> {
  // Controllers for input fields
  late TextEditingController laboratoristController;
  late TextEditingController pieceController;
  late TextEditingController costController;

  @override
  void initState() {
    super.initState();
    laboratoristController = TextEditingController();
    pieceController = TextEditingController();
    costController = TextEditingController();
  }

  @override
  void dispose() {
    laboratoristController.dispose();
    pieceController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context);
    final labProvider = Provider.of<LaboratoryProvider>(context, listen: false);
    final patient = selectedPatientProvider.selectedPatient;

    if (patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(
          child: Text("No se proporcionaron datos del paciente"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: CustomTheme.fillColor,
      body: Column(
        children: [
          // Top container with title and back button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
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
                  'Piezas en laboratorio',
                  style: TextStyle(
                    color: CustomTheme.lettersColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 50,
                  child: CustomButton(
                    text: 'Regresar',
                    color: CustomTheme.fillColor,
                    style: const TextStyle(
                      color: CustomTheme.lettersColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // Display patient name
                  _buildPatientInfoCard('Paciente', patient.name),
                  const SizedBox(height: 20),
                  _buildPatientInfoCard('ID Paciente', patient.id.toString()),

                  const SizedBox(height: 20),

                  // Laboratorist input
                  CustomInput(
                    controller: laboratoristController,
                    keyboardType: TextInputType.text,
                    labelText: 'Laboratorista',
                    hintText: 'Ingrese a qué laboratorista se mandará',
                    icon: Icons.science,
                    borderColor: Colors.transparent,
                    iconColor: Colors.white,
                    fillColor: CustomTheme.containerColor,
                    fontSize: 22,
                  ),

                  const SizedBox(height: 20),

                  // Piece input
                  CustomInput(
                    controller: pieceController,
                    keyboardType: TextInputType.text,
                    labelText: 'Pieza',
                    hintText: '¿Qué pieza se mandará?',
                    icon: Icons.widgets,
                    borderColor: Colors.transparent,
                    iconColor: Colors.white,
                    fillColor: CustomTheme.containerColor,
                    fontSize: 22,
                  ),

                  const SizedBox(height: 20),

                  // Cost input
                  CustomInput(
                    controller: costController,
                    keyboardType: TextInputType.number,
                    labelText: 'Precio',
                    hintText: 'Ingrese el precio que cobra el laboratorista',
                    icon: Icons.attach_money,
                    borderColor: Colors.transparent,
                    iconColor: Colors.white,
                    fillColor: CustomTheme.containerColor,
                    fontSize: 22,
                  ),

                  const SizedBox(height: 30),


                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                                        const SizedBox(height: 30),

                  // Visualizar Piezas en Laboratorio Button
                  CustomButton(
                    text: 'Visualizar Piezas en Laboratorio',
                    width: 250,
                    height: 70,
                    color: CustomTheme.buttonColor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
onPressed: () {
  // Get the selected patient provider
  final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
  
  // Set the selected patient
  selectedPatientProvider.selectPatient(patient, patient.id);
  
  // Navigate to TreatmentPlanView with the correct patient ID
  Navigator.pushNamed(
    context,
    '/LaboratoryViewPage',
    arguments: {'patientId': patient.id}, // Use patient.id instead of selectedPatient.id
  );
},
                  ),

                      // Save Data Button
                      CustomButton(
                        text: 'Guardar Datos',
                        width: 150,
                        height: 70,
                        color: CustomTheme.buttonColor,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        onPressed: () async {
                          final laboratorist = laboratoristController.text;
                          
                          final costText = costController.text;
                          final piece = pieceController.text;
                          final idPatient = int.parse(patient.id.toString());
                          final createdAt = DateTime.now().toIso8601String();

                          if (laboratorist.isEmpty || piece.isEmpty || costText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Todos los campos son obligatorios")),
                            );
                            return;
                          }

                          double? cost = double.tryParse(costText);
                          if (cost == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Ingrese un precio válido")),
                            );
                            return;
                          }

                          bool success = await labProvider.addLaboratoryRecord(
                            idPatient: idPatient,
                            laboratorist: laboratorist,
                            piece: piece,
                            cost: cost,
                            createdAt: createdAt,
                          );

                          if (!context.mounted) return;

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Registro de laboratorio guardado con éxito!")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Error al guardar los datos")),
                            );
                          }
                        },
                      ),
                      
                    ],
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfoCard(String label, String value) {
    return Container(
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
              "$label: $value",
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
    );
  }
}
