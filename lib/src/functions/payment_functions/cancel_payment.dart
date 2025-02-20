 import 'package:flutter/material.dart';
 import 'package:app_herbal_flutter/src/api/provider/payment_services/payment_provider.dart';
 import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
  final TextEditingController amountController = TextEditingController();
  void showCancelConfirmationDialog(BuildContext context) {
  
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomTheme.containerColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: const Text("Cancelar Abono", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: CustomTheme.lettersColor)),
          content: const Text(
            "¿Está seguro de que desea cancelar el abono? Esta acción revertirá los cambios.",
            style: TextStyle(fontSize: 28, color: CustomTheme.lettersColor),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No", style: TextStyle(fontSize: 28, color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<PaymentProvider>(context, listen: false).cancelAbono();
                amountController.clear();
              },
              child: const Text("Sí", style: TextStyle(fontSize: 28, color: Colors.greenAccent)),
            ),
          ],
        );
      },
    );
  }