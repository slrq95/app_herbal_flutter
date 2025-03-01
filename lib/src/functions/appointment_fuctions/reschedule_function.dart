import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/appointement_services/appointment_view_provider.dart';

Future<void> showRescheduleDialog(BuildContext context, int appointmentId, AppointmentViewProvider provider) async {
  DateTime newDate = DateTime.now();
  TimeOfDay newTime = TimeOfDay.now();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Reprogramar Cita"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: newDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 2),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        newDate = pickedDate;
                      });
                    }
                  },
                  child: Text("Fecha seleccionada: ${newDate.toLocal()}".split(' ')[0]),
                ),
                TextButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: newTime,
                    );
                    if (pickedTime != null) {
                      setState(() {
                        newTime = pickedTime;
                      });
                    }
                  },
                  child: Text("Hora seleccionada: ${newTime.hour}:${newTime.minute}"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  String formattedDate = "${newDate.toLocal()}".split(' ')[0];
                  String formattedTime = "${newTime.hour}:${newTime.minute}";

                  try {
                    // Remove the appointment from the UI first
                    provider.removeAppointmentFromList(appointmentId);

                    // Call the provider to reschedule the appointment
                    await provider.rescheduleAppointment(appointmentId, formattedDate, formattedTime);

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cita reprogramada exitosamente."), backgroundColor: Colors.green),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
                    );
                  }

                  Navigator.of(context).pop();
                },
                child: const Text("Confirmar"),
              ),
            ],
          );
        },
      );
    },
  );
}
