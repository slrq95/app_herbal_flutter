import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:app_herbal_flutter/src/components/custom_card.dart';
import 'package:app_herbal_flutter/src/api/provider/laboratory_service/laboratory_view_provider.dart';
import 'package:app_herbal_flutter/src/components/custom_container.dart';

class LaboratoryView extends StatefulWidget {
  final dynamic patientId;

  const LaboratoryView({super.key, required this.patientId});

  @override
  LaboratoryViewState createState() => LaboratoryViewState();
}

class LaboratoryViewState extends State<LaboratoryView> {
  bool hasNavigated = false; // Flag to prevent multiple navigations
  bool hasFetchedData = false; // Prevent multiple API calls

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.patientId != null && !hasFetchedData) {
        hasFetchedData = true; // Ensure API call happens once

        final patientId = widget.patientId is Map<String, String>
            ? widget.patientId['patientId'] ?? ''
            : widget.patientId.toString();

        final provider = Provider.of<LaboratoryViewProvider>(context, listen: false);

        print("Fetching laboratory data for patient ID: $patientId");
        await provider.fetchLaboratoryData(int.parse(patientId));

        if (provider.laboratoryData.isEmpty && mounted && !hasNavigated) {
          hasNavigated = true;
          print("No laboratory data found. Navigating back to /home...");
          
          // Reset the flag and navigate to /home
          Future.delayed(Duration(milliseconds: 2000), () {
            if (mounted) {
              hasFetchedData = false; // Reset the flag when navigating away
              Navigator.of(context).pushReplacementNamed('/home');
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPatientProvider =
        Provider.of<SelectedPatientProvider>(context, listen: false);
    final patient = selectedPatientProvider.selectedPatient;

    if (patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("No se proporcionaron datos del paciente")),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.fillColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<LaboratoryViewProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage != null) {
                return Center(child: Text(provider.errorMessage!));
              }

              if (provider.laboratoryData.isEmpty && provider.errorMessage == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning, color: Colors.amber, size: 50),
                      const SizedBox(height: 10),
                      const Text(
                        "No laboratory data found for this patient.",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: "Go Back",
                        width: 120,
                        height: 50,
                        color: CustomTheme.fillColor,
                        onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: CustomTheme.containerColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Laboratory Records',
                            style: TextStyle(
                              color: CustomTheme.lettersColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomButton(
                            text: 'Regresar',
                            width: 120,
                            height: 50,
                            color: CustomTheme.fillColor,
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed('/home'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.laboratoryData.length,
                      itemBuilder: (context, index) {
                        final record = provider.laboratoryData[index];
                        return CustomCard(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomContainer(
                                  height: 200,
                                  width: 300,
                                  child: Text(
                                    '💉 Id Paciente: ${record['id_patient']}',
                                    style: const TextStyle(
                                      color: CustomTheme.lettersColor,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '💊 Laboratorista: ${record['laboratorist']}',
                                        style: const TextStyle(
                                          color: CustomTheme.lettersColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '📅 pieza: ${(record['piece'])}',
                                        style: const TextStyle(
                                            color: Colors.white70, fontSize: 26),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '📅 costo: ${(record['cost'])}',
                                        style: const TextStyle(
                                            color: Colors.white70, fontSize: 26),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
