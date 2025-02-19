import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/provider/clinical_history/clinical_history_provider.dart';

class ClinicalHistoryPage extends StatefulWidget {
  const ClinicalHistoryPage({super.key});

  @override
  ClinicalHistoryPageState createState() => ClinicalHistoryPageState();
}

class ClinicalHistoryPageState extends State<ClinicalHistoryPage> {
 
  late TextEditingController clinicalHistoryController;
  late TextEditingController patientCharacteristicsController;
  late TextEditingController consultReasonController;
  @override
  Widget build(BuildContext context) {
    final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context);
    final clinicalHistoryProvider = Provider.of<ClinicalHistoryProvider>(context, listen: false);
    final patient = selectedPatientProvider.selectedPatient;

    

    if (patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(
          child: Text("No se proporcionaron datos del paciente"),
        ),
      );
    }

    // Fetch clinical history data only after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      clinicalHistoryProvider.clearData();
      if (!clinicalHistoryProvider.isDataFetched) {
        clinicalHistoryProvider.fetchClinicalHistory(patient.id);
      }
          // If data is not fetched and it's not loading, navigate to the appropriate page
    if (!clinicalHistoryProvider.isLoading && !clinicalHistoryProvider.isDataFetched) {
      Future.microtask(() {
        if (!context.mounted) return;
        Navigator.pushNamed(context, '/ClinicalHistoryPage'); // Navigate only when data isn't found
      });
    }
    });

    
 // Allows normal back navigation
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
                  'Historia Clínica',
                  style: TextStyle(
                    color: CustomTheme.lettersColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 45,
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
                      clinicalHistoryProvider.clearData();
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
                  const SizedBox(height: 20),
                  // Historia Clínica input field
                  Consumer<ClinicalHistoryProvider>(
                    builder: (context, provider, child) {
                      return CustomInput(
                        controller: provider.clinicalHistoryController,  // Use the controller
                        keyboardType: TextInputType.text,
                        labelText: 'Historia Clínica',
                        hintText: 'Ingrese la historia clínica del paciente',
                        icon: Icons.history,
                        borderColor: Colors.transparent,
                        iconColor: Colors.white,
                        fillColor: CustomTheme.containerColor,
                        fontSize: 22,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Características del Paciente input field
                Consumer<ClinicalHistoryProvider>(
                  builder: (context, provider, child) {
                    return 
                  CustomInput(
                    controller: provider.patientCharacteristicsController,
                    keyboardType: TextInputType.text,
                    labelText: 'Características del Paciente',
                    hintText: 'Describa las características del paciente',
                    icon: Icons.info,
                    borderColor: Colors.transparent,
                    iconColor: Colors.white,
                    fillColor: CustomTheme.containerColor,
                    fontSize: 22,
                  );}),
                  const SizedBox(height: 20),
                  // Motivo de la Consulta input field
                  Consumer<ClinicalHistoryProvider>(
                  builder: (context, provider, child) {
                    return 
                  CustomInput(
                    controller: provider.consultReasonController,
                    keyboardType: TextInputType.text,
                    labelText: 'Motivo de la Consulta',
                    hintText: 'Explique el motivo de la consulta',
                    icon: Icons.note_add,
                    borderColor: Colors.transparent,
                    iconColor: Colors.white,
                    fillColor: CustomTheme.containerColor,
                    fontSize: 22,
                  );}),
                  const SizedBox(height: 30),
Consumer<ClinicalHistoryProvider>(
  builder: (context, provider, child) {
    return CustomButton(
      text: ' Odontograma',
      onPressed: () {
        Navigator.pushNamed(context, '/OdontogramPage');
      },
    );
  },
),
                  const SizedBox(height: 30),
                Consumer<ClinicalHistoryProvider>(
                  builder: (context, provider, child) {
                    return // Buttons (Guardar Datos and Actualizar Datos)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Show "Crear Ficha Clinica" if data has not been fetched yet
                      if (!clinicalHistoryProvider.isDataFetched) 
                        CustomButton(
                          text: 'Crear Ficha Clinica',
                          width: 150,
                          height: 70,
                          color: CustomTheme.buttonColor,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          onPressed: () async {
                            final provider = Provider.of<ClinicalHistoryProvider>(context, listen: false);
                            bool success = await provider.createClinicalHistory(patient.id);

                            if (!context.mounted) return;

                            if (success) {
                              Navigator.pushNamed(context, '/home');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Historia Clínica guardada con éxito!")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Error al guardar los datos")),
                              );
                            }
                          },
                        ),
                      // Show "Actualizar Datos" only if data is fetched
                      if (clinicalHistoryProvider.isDataFetched) 
                        CustomButton(
                          text: 'Actualizar Datos',
                          width: 150,
                          height: 70,
                          color: CustomTheme.buttonColor,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          onPressed: () {
                            // Handle the update logic here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Funcionalidad de actualizar datos pendiente")),
                            );
                          },
                        ),
                    ],
                  );}),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

