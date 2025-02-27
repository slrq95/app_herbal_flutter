import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:app_herbal_flutter/src/components/custom_card.dart';

import 'package:app_herbal_flutter/src/api/provider/treatment_plan_services/treatment_view_provider.dart';
import 'package:app_herbal_flutter/src/components/custom_container.dart';

import 'package:app_herbal_flutter/src/functions/treatment_plan_functions/update_function.dart';
class TreatmentPlanView extends StatefulWidget {
  final dynamic patientId; // Add patientId parameter

  const TreatmentPlanView({super.key , required this.patientId});
  @override
  TreatmentPlanViewState createState() => TreatmentPlanViewState();
}
class TreatmentPlanViewState extends State<TreatmentPlanView> {


  @override
  void initState() {
    super.initState();
    debugPrint("Received patientId: ${widget.patientId} - Type: ${widget.patientId.runtimeType}");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.patientId != null) {
        try {
          final String idString = widget.patientId is Map<String, String>
              ? widget.patientId['patientId'] ?? ''
              : widget.patientId.toString();

          await Provider.of<TreatmentViewProvider>(context, listen: false)
              .initialize(int.parse(idString));
        } catch (e) {
          debugPrint("Error parsing patientId: $e");
        }
      } else {
        debugPrint("Error: patientId is null!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
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
          child: Consumer<TreatmentViewProvider>(
            builder: (context, viewProvider, child) {
if (viewProvider.treatmentPlans.isEmpty) {
  return FutureBuilder(
    future: Future.delayed(const Duration(seconds: 2)),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        // After the 2 seconds delay, check the treatment plans
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/home');
        });
        return const Center(child: CircularProgressIndicator());
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
}

      viewProvider.getPatientTreatmentViewPlans(int.parse(patient.id));

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                            'Planes de tratamiento en curso',
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
                            onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Consumer<TreatmentViewProvider>(
                      builder: (context, provider, child) {
                        final treatmentPlans = provider.treatmentPlans;

                        if (treatmentPlans.isEmpty) {
                          return const Center(
                            child: Text(
                              "No hay planes de tratamiento registrados.",
                              style: TextStyle(color: CustomTheme.lettersColor, fontSize: 18),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: treatmentPlans.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final treatment = treatmentPlans[index];


                            return CustomCard(
                              height: 400,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomContainer(
                                      height: 200,
                                      width: 300,
                                      child:                   Text(
                                            '💊 notas : ${treatment['note']}',
                                            style: const TextStyle(
                                              color: CustomTheme.lettersColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '💊 Tratamiento: ${treatment['plan_treatment']}',
                                            style: const TextStyle(
                                              color: CustomTheme.lettersColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '🦴 Parte del cuerpo: ${treatment['body_part']}',
                                            style: const TextStyle(color: Colors.white, fontSize: 24),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Precio: ${treatment['price']}',
                                            style: const TextStyle(color: Colors.white70, fontSize: 22),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            '📅 Creado el: ${treatment['created_at']}',
                                            style: const TextStyle(color: Colors.white70, fontSize: 22),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            '📅 acualizado en : ${treatment['updated_at']}',
                                            style: const TextStyle(color: Colors.white70, fontSize: 22),
                                          ),
                                                        

                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () => showEditDialog(context, treatment),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: CustomTheme.tertiaryColor,
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                ),
                                                child: const Text("Editar", style: TextStyle(fontSize: 24, color: Colors.white)),
                                                  ),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                        
                              
                            );
                          },
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

