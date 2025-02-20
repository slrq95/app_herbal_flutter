import'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart'
;
Future<void> showCancelAppointmentConfirmationDialog(BuildContext context) async {
  // Show the confirmation dialog
  bool? cancelConfirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: CustomTheme.containerColor,
        title: const Text(
          'Seguro que quiere cancelar la cita?',
          style: TextStyle(
            color: CustomTheme.lettersColor, // Set the text color to white
            fontSize: 28, // Set the font size to 28
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // No, don't cancel
            },
            child: const Text(
              'No',
              style: TextStyle(
                color: CustomTheme.lettersColor, // Set the text color to white
                fontSize: 28, // Set the font size to 28
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Yes, cancel
            },
            child: const Text(
              'Sí',
              style: TextStyle(
                color: CustomTheme.lettersColor, // Set the text color to white
                fontSize: 28, // Set the font size to 28
              ),
            ),
          ),
        ],
      );
    },
  );

  if (cancelConfirmed == true) {
    // If the user confirmed cancellation, call the API to update the status
    _cancelAppointment();
  }
}

void _cancelAppointment() {
  // API call to update the status to 'cancelada'
  // Assuming you have an API function to handle this
  debugPrint("Cita cancelada y estado actualizado a 'cancelada'");
  // Implement your API call here to change the status to 'cancelada'
}