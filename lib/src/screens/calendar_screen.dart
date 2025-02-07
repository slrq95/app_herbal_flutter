import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:app_herbal_flutter/src/components/custom_calendar.dart'; // Import the custom calendar
import 'package:app_herbal_flutter/src/theme/default.dart';

class PantallaCalendario extends StatefulWidget {
  const PantallaCalendario({super.key});

  @override
  State<PantallaCalendario> createState() => _PantallaCalendarioState();
}

class _PantallaCalendarioState extends State<PantallaCalendario> {
  final Map<DateTime, List<Map<String, dynamic>>> _appointments = {};
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final List<String> categories = ["Cleaning", "Consultation", "Surgery"];
  final List<String> priorities = ["High", "Medium", "Low"];

  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    return _appointments[day] ?? [];
  }

  void _onDateSelected(DateTime newDate) {
    setState(() {
      _selectedDay = newDate;
      _focusedDay = newDate;
    });
  }

  void _addOrEditAppointment({Map<String, dynamic>? existingAppointment}) {
    final TextEditingController pacienteController = TextEditingController(
      text: existingAppointment?['paciente'] ?? '',
    );
    final TextEditingController appointmentController = TextEditingController(
      text: existingAppointment?['descripcion'] ?? '',
    );
    String selectedCategory = existingAppointment?['categoria'] ?? categories[0];
    String selectedPriority = existingAppointment?['prioridad'] ?? priorities[1];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingAppointment == null ? 'Agregar Cita' : 'Editar Cita'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: pacienteController,
                  decoration: const InputDecoration(labelText: 'Paciente'),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: appointmentController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedCategory = value!;
                  },
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: const InputDecoration(labelText: 'Prioridad'),
                  items: priorities.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedPriority = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (pacienteController.text.isNotEmpty && appointmentController.text.isNotEmpty) {
                  setState(() {
                    if (existingAppointment != null) {
                      _appointments[_selectedDay]?.remove(existingAppointment);
                    }
                    if (_appointments[_selectedDay] == null) {
                      _appointments[_selectedDay] = [];
                    }
                    _appointments[_selectedDay]!.add({
                      'paciente': pacienteController.text,
                      'descripcion': appointmentController.text,
                      'categoria': selectedCategory,
                      'prioridad': selectedPriority,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAppointment(Map<String, dynamic> appointment) {
    setState(() {
      _appointments[_selectedDay]?.remove(appointment);
      if (_appointments[_selectedDay]?.isEmpty ?? true) {
        _appointments.remove(_selectedDay);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Set the background color to #121212
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), // Set app bar background color
        title: const Hero(
          tag: 'calendarioScreen',
          child: Text('Calendario'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addOrEditAppointment,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Content overlay
          Column(
            children: [
              const Hero(
                tag: 'calendarioContent',
                child: Icon(
                  Icons.calendar_month,
                  size: 120.0,
                  color: CustomTheme.fillColor,
                ),
              ),

              // Custom Calendar (Week View)
              CustomCalendar(
                initialDate: _selectedDay,
                onDateSelected: _onDateSelected,
              ),

              const SizedBox(height: 10),

              // Table Calendar (Month View)
              TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: CustomTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white, // Change text color to white
                  ),
                  weekendTextStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.red,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),

              const SizedBox(height: 8.0),

              // Appointment List
              Expanded(
                child: _getAppointmentsForDay(_selectedDay).isEmpty
                    ? const Center(
                        child: Text(
                          'No hay citas para este día',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _getAppointmentsForDay(_selectedDay).length,
                        itemBuilder: (context, index) {
                          final appointment = _getAppointmentsForDay(_selectedDay)[index];
                          return Card(
                            elevation: 4,
                            color: const Color(0xFF1E1E1E), // Set the color for the cards
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: ListTile(
                              title: Text(
                                'Paciente: ${appointment['paciente']}',
                                style: const TextStyle(color: Colors.white), // Set the text color to white
                              ),
                              subtitle: Text(
                                'Descripción: ${appointment['descripcion']}',
                                style: const TextStyle(color: Colors.white), // Set the text color to white
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteAppointment(appointment),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
