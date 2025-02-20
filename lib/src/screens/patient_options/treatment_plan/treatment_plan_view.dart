import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/api/provider/payment_services/payment_provider.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:app_herbal_flutter/src/components/custom_card.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/api/provider/treatment_plan_services/treatment_view_provider.dart';
import 'package:app_herbal_flutter/src/components/custom_container.dart';

void showEditDialog(BuildContext context, Map<String, dynamic> treatment) {
  final treatmentProvider = Provider.of<TreatmentViewProvider>(context, listen: false);
  final TextEditingController treatmentController =
      TextEditingController(text: treatment['plan_treatment']);
  final TextEditingController bodyPartController =
      TextEditingController(text: treatment['body_part']);
        final TextEditingController priceController =
      TextEditingController(text: treatment['price'].toString());
  final TextEditingController noteController =
      TextEditingController(text: treatmentProvider.getNote(treatment['id_plan']));

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
              fillColor:CustomTheme.containerColor ,
              iconColor: CustomTheme.buttonColor,
              borderColor: CustomTheme.containerColor,
              keyboardType: const TextInputType.numberWithOptions(),
              controller: treatmentController,
              labelText: "Tratamiento",
              hintText: "Ingrese tratamiento...",
              icon: Icons.medical_services,
            ),
            const SizedBox(height: 10),
            CustomInput(
                            fillColor:CustomTheme.containerColor,
              iconColor: CustomTheme.buttonColor,
              borderColor: CustomTheme.containerColor,
              keyboardType: const TextInputType.numberWithOptions(),
              controller: bodyPartController,
              labelText: "Parte del cuerpo",
              hintText: "Ingrese parte del cuerpo...",
              icon: Icons.accessibility,
            ),
            const SizedBox(height: 10),
            CustomInput(
                            fillColor:CustomTheme.containerColor ,
              iconColor: CustomTheme.buttonColor,
              borderColor: CustomTheme.containerColor,
              keyboardType: const TextInputType.numberWithOptions(),
              controller: priceController,
              labelText: "Editar precio",
              hintText: "Ingrese precio ",
              icon: Icons.note,
            ),
                        const SizedBox(height: 10),
            CustomInput(
                            fillColor:CustomTheme.containerColor ,
              iconColor: CustomTheme.buttonColor,
              borderColor: CustomTheme.containerColor,
              keyboardType: const TextInputType.numberWithOptions(),
              controller: noteController,
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
            onPressed: () {
              treatmentProvider.updateNote(treatment['id_plan'], noteController.text);
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      );
    },
  );
}

class TreatmentPlanView extends StatefulWidget {
  final dynamic patientId; // Add patientId parameter

  const TreatmentPlanView({super.key , required this.patientId});
  @override
  TreatmentPlanViewState createState() => TreatmentPlanViewState();
}
class TreatmentPlanViewState extends State<TreatmentPlanView> {
  final TextEditingController binnacleController = TextEditingController();
  String enteredText = ""; // Variable to store user input

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

          await Provider.of<PaymentProvider>(context, listen: false)
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
          child: Consumer<PaymentProvider>(
            builder: (context, paymentProvider, child) {
              if (paymentProvider.treatmentPlans.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

            
                  paymentProvider.getPatientTreatmentPlans(int.parse(patient.id));

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
                            width: 100,
                            height: 40,
                            color: CustomTheme.fillColor,
                            onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Consumer<PaymentProvider>(
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

                            return ChangeNotifierProvider(
                              create: (_) => TreatmentViewProvider(),
                              child: Consumer<TreatmentViewProvider>(
                                builder: (context, treatmentProvider, child) {
                                  final treatmentId = treatment['id_plan'];
                                  final TextEditingController noteController =
                                      TextEditingController(
                                          text: treatmentProvider.getNote(treatmentId));

                                  return CustomCard(
                                    height: 350,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // ✅ Left Side: Display Notes
                                          CustomContainer(
                                            height: 200,
                                            width: 300,
                                           // padding: const EdgeInsets.all(8),

                                            child: Text(
                                              treatmentProvider.getNote(treatmentId).isNotEmpty
                                                  ? treatmentProvider.getNote(treatmentId)
                                                  : "Sin notas",
                                              style: const TextStyle(color: Colors.white, fontSize: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(width: 10),

                                          // ✅ Right Side: Treatment Plan Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '💊 Tratamiento: ${treatment['plan_treatment']}',
                                                  style: const TextStyle(
                                                    color: CustomTheme.lettersColor,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '🦴 Parte del cuerpo: ${treatment['body_part']}',
                                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Precio: ${treatment['price']}',
                                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                                ),
                                                const SizedBox(height: 10),
                                                  Text(
                                                  '📅 Creado el: ${treatment['created_at']}',
                                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                                ),

                                                // ✅ Custom Input for Notes
                                                CustomInput(
                                                  controller: noteController,
                                                  keyboardType: TextInputType.text,
                                                  labelText: "Notas",
                                                  hintText: "Ingrese notas aquí...",
                                                  icon: Icons.note,
                                                  borderColor: Colors.white,
                                                  iconColor: Colors.white,
                                                  fillColor: CustomTheme.containerColor,
                                                  width: double.infinity,
                                                  height: 80,
                                                  fontSize: 18,
                                                  onChanged: (value) {
                                                    treatmentProvider.updateNote(treatmentId, value ?? "");
                                                  },
                                                ),

                                                const SizedBox(height: 10),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    CustomButton(
                                                      text: 'Guardar Nota',
                                                      width: 150,
                                                      height: 50,
                                                      onPressed: () {
                                                        final newNote = noteController.text.trim();
                                                        treatmentProvider.updateNote(treatmentId, newNote);
                                                        debugPrint("Guardando nota para $treatmentId: $newNote");
                                                      },
                                                    ),

                                                    // ✅ Edit Button Added Here
ElevatedButton(
  onPressed: () => showEditDialog(context, treatment),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blueAccent,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  child: const Text("Editar", style: TextStyle(fontSize: 16, color: Colors.white)),
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
