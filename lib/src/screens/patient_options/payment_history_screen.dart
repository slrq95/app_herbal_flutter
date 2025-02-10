import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/components/custom_container.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/api/payment_provider.dart';
import 'package:app_herbal_flutter/src/functions/payment_functions/cancel_payment.dart';
import 'package:app_herbal_flutter/src/functions/payment_functions/confirm_payment.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  PaymentHistoryState createState() => PaymentHistoryState();
}

class PaymentHistoryState extends State<PaymentHistory> {
  final TextEditingController amountController = TextEditingController();
@override
  void initState() {
    super.initState();
    Provider.of<PaymentProvider>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(  // Wrap the entire Scaffold with SafeArea
      child: Scaffold(
        backgroundColor: CustomTheme.fillColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<PaymentProvider>(
            builder: (context, paymentProvider, child) {
              return Column(
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
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

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
                          'Pagos Realizados',
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
                          'Pagos Pendientes',
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

                  CustomButton(text: 'Guardar Datos', width: 200, height: 70, onPressed: () {}),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}