import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final TextEditingController nameController = TextEditingController(text: "Nombre del Paciente");
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
 
  final TextEditingController reprogramDateController = TextEditingController();
  final TextEditingController reprogramTimeController = TextEditingController(); // New controller for reprogrammed time
  String priority = 'Alta';
  String type = 'Consulta';
  String status = 'Atendida';

  // Function to select date
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  // Function to select time
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        controller.text = pickedTime.format(context); // Format as "HH:mm"
      });
    }
  }

  // Function to handle reprogramming date and time
  void _reprogramDateTime() {
    setState(() {
      // Update the original fields with the new values
      dateController.text = reprogramDateController.text;
      timeController.text = reprogramTimeController.text;
    });
  }

Future<void> _showCancelConfirmationDialog(BuildContext context) async {
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
  print("Cita cancelada y estado actualizado a 'cancelada'");
  // Implement your API call here to change the status to 'cancelada'
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.fillColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header Instead of AppBar
            Container(
              height: 90,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: CustomTheme.containerColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Historial de Citas',
                    style: TextStyle(color: CustomTheme.lettersColor, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  CustomButton(
                    text: 'Regresar',
                    color: CustomTheme.fillColor,
                    width: 120,
                    height: 40,
                    style: const TextStyle(fontSize: 22, color: CustomTheme.lettersColor),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
                  // Non-editable Patient Name input field
                  Container(
                    width: double.infinity,
                    height: 70.0,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E), // Background color
                    borderRadius: BorderRadius.circular(10),
                      ),
                    child: Row(
                      children: [
                      const Icon(Icons.person, color: Colors.white), // User icon
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                        nameController.text.isNotEmpty 
                        ? nameController.text // Display patient name if available
                        : 'Cargando...', // Placeholder while fetching data
                        style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                          ),
                        overflow: TextOverflow.ellipsis, // Handles long names
                      ),
                    ),
                    ],
                  ),
                ),
            const SizedBox(height: 50),
            // Fecha Input (Date Picker)
            GestureDetector(
              onTap: () => _selectDate(context, dateController),
              child: AbsorbPointer(
                child: CustomInput(
                  controller: dateController,
                  keyboardType: TextInputType.datetime,
                  labelText: 'Fecha de la Cita',
                  hintText: 'Seleccione la fecha',
                  icon: Icons.calendar_today,
                  borderColor: Colors.grey,
                  iconColor: CustomTheme.lettersColor,
                  fillColor: CustomTheme.containerColor,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Hora Input (Time Picker)
            GestureDetector(
              onTap: () => _selectTime(context, timeController),
              child: AbsorbPointer(
                child: CustomInput(
                  controller: timeController,
                  keyboardType: TextInputType.datetime,
                  labelText: 'Hora de la Cita',
                  hintText: 'Seleccione la hora',
                  icon: Icons.access_time,
                  borderColor: Colors.grey,
                  iconColor: CustomTheme.lettersColor,
                  fillColor: CustomTheme.containerColor,
                ),
              ),
            ),
            const SizedBox(height: 30),
  
            DropdownButtonFormField<String>(
              value: priority,
              dropdownColor: CustomTheme.containerColor,
              decoration: InputDecoration(
                labelText: 'Prioridad',
                labelStyle: const TextStyle(color: CustomTheme.lettersColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
              items: ['Alta', 'Media', 'Baja'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: CustomTheme.lettersColor)),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => priority = newValue!),
            ),
            const SizedBox(height: 50),
            DropdownButtonFormField<String>(
              value: type,
              dropdownColor: CustomTheme.containerColor,
              decoration: InputDecoration(
                labelText: 'Tipo',
                labelStyle: const TextStyle(color: CustomTheme.lettersColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
              ),
              items: ['Consulta', 'Reconsulta', 'Procedimiento'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: CustomTheme.lettersColor)),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => type = newValue!),
            ),
            const SizedBox(height: 50),
                            CustomButton(
                  height: 80,
                  width: 200,
                  text: 'Guardar Datos',
                  color: CustomTheme.buttonColor,
                  onPressed: () {
                    // Implement API call to save data
                  },
                ),
              const SizedBox(height: 180),
            // Reprogramar Cita Input
            GestureDetector(
              onTap: () => _selectDate(context, reprogramDateController),
              child: AbsorbPointer(
                child: CustomInput(
                  controller: reprogramDateController,
                  keyboardType: TextInputType.datetime,
                  labelText: 'Reprogramar Cita',
                  hintText: 'Seleccione nueva fecha',
                  icon: Icons.edit_calendar,
                  borderColor: Colors.grey,
                  iconColor: CustomTheme.lettersColor,
                  fillColor: CustomTheme.containerColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Reprogramar Hora de la Cita Input
            GestureDetector(
              onTap: () => _selectTime(context, reprogramTimeController),
              child: AbsorbPointer(
                child: CustomInput(
                  controller: reprogramTimeController,
                  keyboardType: TextInputType.datetime,
                  labelText: 'Reprogramar Hora de la Cita',
                  hintText: 'Seleccione nueva hora',
                  icon: Icons.access_time,
                  borderColor: Colors.grey,
                  iconColor: CustomTheme.lettersColor,
                  fillColor: CustomTheme.containerColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                CustomButton(
                height: 80,
                width: 200,
                text: 'Cancelar Cita',
                color: CustomTheme.secondaryColor,
                onPressed: () {
                  _showCancelConfirmationDialog(context); // Show dialog when the button is pressed
                  },
                  ),
                
            CustomButton(
              height: 80,
              width: 200,
              text: 'Reprogramar Cita',
              color: CustomTheme.primaryColor,
              onPressed: _reprogramDateTime, // Call the reprogramming function
            ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
