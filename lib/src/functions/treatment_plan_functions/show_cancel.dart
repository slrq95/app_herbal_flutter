import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/provider/treatment_plan_services/treatment_plan_provider.dart';

Future<void> showCancelConfirmationDialog(BuildContext context, int index) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E), // Dark Background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded Corners
        title: const Text(
          '¿Estás seguro?',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: const SizedBox(
          width: 300, // Adjust Dialog Width
          child: Text(
            '¿Quieres cancelar este tratamiento?',
            style: TextStyle(fontSize: 26, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, 
              backgroundColor: Colors.grey[700], 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: const Text('No', style: TextStyle(fontSize: 20)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              Provider.of<TreatmentPlanProvider>(context, listen: false).removeTreatment(index);
            },
            child: const Text('Sí', style: TextStyle(fontSize: 20)),
          ),
        ],
      );
    },
  );
}
