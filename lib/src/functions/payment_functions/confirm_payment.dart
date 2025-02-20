import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/provider/payment_services/payment_provider.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
void showConfirmationDialog(BuildContext context, double abono, TextEditingController amountController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: CustomTheme.containerColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: const Text("Confirmar Abono", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: CustomTheme.lettersColor)),
        content: Text(
          "¿Desea realizar el abono de Q${abono.toStringAsFixed(2)}?",
          style: const TextStyle(fontSize: 26, color: CustomTheme.lettersColor),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(fontSize: 28, color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<PaymentProvider>(context, listen: false).confirmAbono(abono);
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
  if (abono > 0 && abono <= Provider.of<PaymentProvider>(context, listen: false).abonosPendientes) {
    showConfirmationDialog(context, abono, amountController);
  } else {
    // Show an error message if the payment is invalid
  }
}