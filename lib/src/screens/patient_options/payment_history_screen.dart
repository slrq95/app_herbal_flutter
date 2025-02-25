import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/components/custom_container.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/api/provider/payment_services/payment_provider.dart';
import 'package:app_herbal_flutter/src/functions/payment_functions/cancel_payment.dart';
import 'package:app_herbal_flutter/src/functions/payment_functions/confirm_payment.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:app_herbal_flutter/src/components/custom_card.dart';
import 'package:app_herbal_flutter/src/functions/payment_functions/widgets_text.dart';
import 'package:app_herbal_flutter/src/api/provider/payment_services/payment_service.dart';

class PaymentHistory extends StatefulWidget {
  final dynamic patientId; // Add patientId parameter

  const PaymentHistory({super.key, required this.patientId});
  @override
  PaymentHistoryState createState() => PaymentHistoryState();
}

class PaymentHistoryState extends State<PaymentHistory> {
  final TextEditingController amountController = TextEditingController();
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
await Provider.of<PaymentProvider>(context, listen: false).initialize(int.parse(widget.patientId));
  });
}
  @override
  Widget build(BuildContext context) {
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
  
  // ✅ Get the treatment plans for the selected patient

  // Log the treatment plans
    return SafeArea(  // Wrap the entire Scaffold with SafeArea
      child: Scaffold(
        backgroundColor: CustomTheme.fillColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<PaymentProvider>(
            builder: (context, paymentProvider, child) {
              
                            // You can check if data is still being fetched
              if (paymentProvider.treatmentPlans.isEmpty) {
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
              
              final patientTreatmentPlans = paymentProvider.getPatientTreatmentPlans(int.parse(patient.id));
              debugPrint("Treatment Plans: $patientTreatmentPlans");
              return SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top container with title and back button
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
                          'Historial de Pagos',
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
                  // Non-editable Patient Name input field
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
                  // Non-editable Patient Name input field
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
 
                              Consumer<PaymentProvider>(
                                builder: (context, provider, child) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: provider.treatmentPlans.length,
                                    itemBuilder: (context, index) {
                                      final treatment = provider.treatmentPlans[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                        child: CustomCard(
                                          height:270,
                                          elevation: 4, // Adds depth to the card
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16), // Softer rounded edges
                                          ),
                                          color: CustomTheme.containerColor, // Background color
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0), // Internal padding
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                buildTitleText('Parte del cuerpo:', treatment['body_part']),
                                                buildTitleText('Plan de tratamiento:', treatment['plan_treatment']),
                                                buildPriceText('Precio:', treatment['price']),
                                                buildText('ID del Plan:', treatment['id_plan']),
                                                buildText('Fecha de creación:', treatment['created_at']),
                                                buildText('Notas:', treatment['note']),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                        // Amount Input Field
                      CustomInput(
            
                        fillColor: CustomTheme.containerColor,
                        iconColor: CustomTheme.buttonColor,
                        borderColor: CustomTheme.buttonColor,
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        labelText: 'Monto a pagar',
                        hintText: 'Ingrese el monto',
                        icon: Icons.money,
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(text: 'Confirmar Pago', width: 130, height: 70, color: CustomTheme.primaryColor ,onPressed: () => onConfirmButtonPressed(context,amountController)),
                          CustomButton(text: 'Cancelar Pago', width: 130, height: 70, color: CustomTheme.secondaryColor, onPressed: () => showCancelConfirmationDialog(context)),
                        ],
                      ),
                  const SizedBox(height: 30),

                  // Payment Data Display Containers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomContainer(
                        color: CustomTheme.fillColor,
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 90,
                        child: const Text(
                          'Pago actual Q.',
                          style: TextStyle(color: CustomTheme.primaryColor, fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomContainer(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 90,
                        child: Text(
                          paymentProvider.abonosRealizados.toStringAsFixed(2), // Access data from provider
                          style: const TextStyle(color: CustomTheme.primaryColor, fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomContainer(
                        color: CustomTheme.fillColor,
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 90,
                        child: const Text(
                          'Pagos Realizados',
                          style: TextStyle(color: CustomTheme.primaryColor, fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomContainer(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 90,
                        child: Text( 
                          paymentProvider.totalPayment.toStringAsFixed(2), // Access data from provider
                          style: const TextStyle(color: CustomTheme.primaryColor, fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),                     
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomContainer(
                        color: CustomTheme.fillColor,
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 90,
                        child: const Text(
                          'Pagos Pendientes Q.',
                          style: TextStyle(color: Colors.redAccent, fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomContainer(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 90,
                        child: Text( 
                          paymentProvider.abonosPendientes.toStringAsFixed(2), // Access data from provider
                          style: const TextStyle(color: Colors.redAccent, fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                    ],
                  ),
                  const SizedBox(height: 30),

CustomButton(
  text: 'Guardar Datos',
  width: 200,
  height: 70,
  onPressed: () async {
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
    final patient = selectedPatientProvider.selectedPatient;

    if (patient == null || paymentProvider.treatmentPlans.isEmpty) {
      debugPrint("Error: No patient or treatment plans found");
      return;
    }

    final actualPayment = paymentProvider.abonosRealizados; // Total payment value

    try {
      // ✅ Send data **only once** for the patient
      await PaymentService().addPayment(
        int.parse(patient.id),
        actualPayment,
      );

      debugPrint("Payment sent successfully for Patient ID: ${patient.id}");

      // Clear the input field and reset the provider state
      amountController.clear();
      paymentProvider.resetCurrentPayment(); // Reset payment value

      // Fetch updated treatment plans and total payment
      await paymentProvider.fetchTreatmentPlans(int.parse(patient.id)); // Fetch updated treatment plans
      await paymentProvider.fetchTotalPayment(int.parse(patient.id)); // Fetch updated total payment

      // Explicitly recalculate abonosPendientes
      paymentProvider.abonosPendientes = (paymentProvider.treatmentPlans.fold(0.0, (sum, plan) => sum + plan["price"])) - paymentProvider.totalPayment - paymentProvider.abonosRealizados;

      // Notify listeners to update the UI
      //paymentProvider.notifyListeners();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Pagos guardados con éxito!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint("Error sending payment: $e");

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al guardar el pago."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  },
),
                ],
              ));
            },
          ),
        ),
      ),
    );
  }
}