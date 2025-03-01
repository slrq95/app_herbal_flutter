import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/provider/payment_services/payment_view_provider.dart';
import 'package:app_herbal_flutter/src/components/custom_card.dart';

class PaymentViewScreen extends StatefulWidget {
  const PaymentViewScreen({super.key});

  @override
  PaymentViewScreenState createState() => PaymentViewScreenState();
}

class PaymentViewScreenState extends State<PaymentViewScreen> {
  @override
  void initState() {
    
    super.initState();
    
    Future.microtask(() {
      
      final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
      final paymentProvider = Provider.of<ViewPaymentProvider>(context, listen: false);

      // ✅ Get the selected patient safely
      final selectedPatient = selectedPatientProvider.selectedPatient;

      if (selectedPatient != null) {
        paymentProvider.getPayments(selectedPatient.id);
      } else {
        debugPrint("No patient selected!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<ViewPaymentProvider>(context);
    final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context);

    return Scaffold(
      backgroundColor: CustomTheme.fillColor,
      body: Column(
        children: [
          // ✅ Custom top container instead of AppBar
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
                  ' Ficha Clínica',
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
                      
                    },
                  ),
                ),
              ],
            ),
          ),

          // ✅ Payment List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (paymentProvider.isLoading)
                    const CircularProgressIndicator()
                  else if (paymentProvider.errorMessage != null)
                    Text(paymentProvider.errorMessage!, style: const TextStyle(color: Colors.red)),
                  if (paymentProvider.payments.isEmpty && !paymentProvider.isLoading)
                    Text("No payments found for ${selectedPatientProvider.selectedPatient?.name ?? 'this patient'}"),
                  Expanded(
                    child: ListView.builder(
                      itemCount: paymentProvider.payments.length,
                      itemBuilder: (context, index) {
                        final payment = paymentProvider.payments[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: CustomCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pago realizado: Q${payment['actual_payment']}",
                                  style: const TextStyle(fontSize: 26, color: Colors.white),
                                ),
                                const SizedBox(height: 8),
Text(
  "Fecha del pago: ${DateTime.parse(payment['created_at']).toLocal()}",
  style: const TextStyle(fontSize: 16, color: Colors.white),
),
                                Text(
                                  "Nota: ${payment['note']}",
                                  style: const TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
