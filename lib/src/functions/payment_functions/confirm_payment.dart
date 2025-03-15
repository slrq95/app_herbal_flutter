import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:app_herbal_flutter/src/api/provider/payment_services/payment_provider.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';

void showConfirmationDialog(
  BuildContext context,
  double abono,
  TextEditingController amountController,
  String timestamp,
  TextEditingController noteController,
  
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: CustomTheme.containerColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: const Text(
          "Confirmar Abono",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: CustomTheme.lettersColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "¿Desea realizar el abono de Q${abono.toStringAsFixed(2)}?",
              style: const TextStyle(fontSize: 26, color: CustomTheme.lettersColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Fecha y Hora: $timestamp",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CustomTheme.lettersColor),
            ),
            const SizedBox(height: 12),

          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(fontSize: 28, color: Colors.redAccent)),
          ),
TextButton(
  onPressed: () {
    String note = noteController.text.trim();  // Ensure we get user input

    // Debugging
    debugPrint("User Input Note: $note");

    Navigator.pop(context);

    // Call Provider function with timestamp and actual user note
    Provider.of<PaymentProvider>(context, listen: false).confirmAbono(abono, timestamp);

    amountController.clear();
  },
  child: const Text("Aceptar", style: TextStyle(fontSize: 28, color: Colors.greenAccent)),
),
        ],
      );
    },
  );
}

void onConfirmButtonPressed(BuildContext context, TextEditingController amountController) {
  double abono = double.tryParse(amountController.text) ?? 0.0;
  final provider = Provider.of<PaymentProvider>(context, listen: false);

  if (abono <= 0 || abono > provider.abonosPendientes) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error: Monto de pago no válido."),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  TextEditingController noteController = TextEditingController();

  showConfirmationDialog(context, abono, amountController, timestamp, noteController);
}
