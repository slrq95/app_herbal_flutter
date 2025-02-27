import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/components/custom_calendar/custom_calendar_draft.dart';
import 'package:app_herbal_flutter/src/components/custom_card.dart';
import 'package:app_herbal_flutter/src/api/provider/appointement_services/appointment_view_provider.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';

class ScreenCalendar extends StatefulWidget {
  const ScreenCalendar({super.key});

  @override
  ScreenCalendarState createState() => ScreenCalendarState();
}

class ScreenCalendarState extends State<ScreenCalendar> {
  DateTime selectedDate = DateTime.now();

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });

    // ✅ Fetch Appointments when a date is selected
    Provider.of<AppointmentViewProvider>(context, listen: false)
        .fetchAppointmentsByDate(date.toLocal().toString().split(' ')[0]);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppointmentViewProvider>(context);

    return Scaffold(
      backgroundColor: CustomTheme.fillColor,
      appBar: AppBar(
        backgroundColor: CustomTheme.primaryColor,
        title: const Text(
          "Calendario de citas",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
  child: Column(
    children: [
      SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomCalendarDraft(
            initialDate: selectedDate,
            onDateSelected: _onDateSelected,
          ),
        ),
      ),
      const SizedBox(height: 20),

      Text(
        "Citas : ${selectedDate.toLocal()}".split(' ')[0],
        style: const TextStyle(color: Colors.white70, fontSize: 28),
      ),

      const SizedBox(height: 10),

      if (provider.isLoading) 
        const CircularProgressIndicator(),

      if (provider.errorMessage != null)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            provider.errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),

      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5, // Ensures bounded height
        child: provider.appointments.isEmpty
            ? const Center(
                child: Text(
                  "No hay citas para este dia",
                  style: TextStyle(color: CustomTheme.lettersColor, fontSize: 26),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: provider.appointments.length,
                itemBuilder: (context, index) {
                  final appointment = provider.appointments[index];

                  return CustomCard(
                    height: 350,
                    padding: const EdgeInsets.all(12.0),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " Hora de la cita: ${appointment['time']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          " id: ${appointment['id_appointment'] ?? 'No details available'}",
                          style: const TextStyle(color: CustomTheme.lettersColor, fontSize: 26),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          " Nombre: ${appointment['name'] ?? 'No details available'}",
                          style: const TextStyle(color: CustomTheme.lettersColor, fontSize: 26),
                        ),
                        Text(
                          " Razon de consulta: ${appointment['reason'] ?? 'No details available'}",
                          style: const TextStyle(color: CustomTheme.lettersColor, fontSize: 26),
                        ),
                        Text(
                          " Prioridad: ${appointment['priority'] ?? 'No details available'}",
                          style: const TextStyle(color: CustomTheme.lettersColor, fontSize: 26),
                        ),
                        Text(
                          " Tipo : ${appointment['type'] ?? 'No details available'}",
                          style: const TextStyle(color: CustomTheme.lettersColor, fontSize: 26),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomButton(
                              elevation: 9,
                              icon: Icons.check_circle_outline,
                              iconColor: Colors.white,
                              borderRadius: 60.0,
                              borderColor: Colors.green,
                              borderWidth: 6.0,
                              text: "Atendida",
                              color: CustomTheme.primaryColor,
                              width: 200,
                              height: 50,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirmación"),
                                      content: const Text("¿Estás seguro de marcar esta cita como atendida?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text("Cancelar"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            provider.updateAppointmentStatus(
                                              appointment['id_appointment'],
                                              "atendida",
                                            ).then((_) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Cita marcada como atendida."),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }).catchError((e) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Error: $e"),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            });
                                          },
                                          child: const Text("Confirmar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            CustomButton(
                              elevation: 5,
                              icon: Icons.cancel_outlined,
                              iconColor: Colors.white,
                              borderRadius: 30.0,
                              borderColor: Colors.red,
                              borderWidth: 6.0,
                              text: "No Atendida",
                              color: CustomTheme.secondaryColor,
                              width: 200,
                              height: 50,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirmación"),
                                      content: const Text("¿Estás seguro de marcar esta cita como no atendida?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text("Cancelar"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            provider.updateAppointmentStatus(
                                              appointment['id_appointment'],
                                              "no atendida",
                                            ).then((_) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Cita marcada como no atendida."),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }).catchError((e) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Error: $e"),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            });
                                          },
                                          child: const Text("Confirmar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    ],
  ),
)

    );
  }
}
