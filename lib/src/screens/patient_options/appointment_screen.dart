import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/provider/appointement_services/appointment_provider.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:app_herbal_flutter/src/models/appointment_model.dart';


class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});
@override
  AppointmentPageState createState() => AppointmentPageState();
}

class AppointmentPageState extends State<AppointmentPage> {

  @override
  Widget build(BuildContext context) {
    final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
    

    final patient = selectedPatientProvider.selectedPatient;

    if (patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(
          child: Text("No se proporcionaron datos del paciente"),
        ),
      );
    }  
    return Scaffold(
      backgroundColor: CustomTheme.fillColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AppointmentProvider>(
            builder: (context, appointmentProvider, child) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(), // Adds smooth scrolling
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Header Instead of AppBar
                    Container(
                      height: 80,
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
                            style: TextStyle(
                              color: CustomTheme.lettersColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomButton(
                            text: 'Regresar',
                            color: CustomTheme.fillColor,
                            width: 120,
                            height: 50,
                            style: const TextStyle(fontSize: 18, color: CustomTheme.lettersColor),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/home');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Non-editable Patient Name Container
                  Container(
                    width: double.infinity,
              
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomTheme.containerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            patient.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                    const SizedBox(height: 20),
                                        // Non-editable Patient Name Container
                  Container(
                    width: double.infinity,
              
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomTheme.containerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            patient.id,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                    const SizedBox(height: 20),
                    // Reason Input (Text Field)
                    CustomInput(
                      controller: appointmentProvider.reasonController,
                      keyboardType: TextInputType.text,
                      labelText: 'Motivo de la Cita',
                      hintText: 'Escriba el motivo de la cita',
                      icon: Icons.description,
                      borderColor: Colors.grey,
                      iconColor: CustomTheme.lettersColor,
                      fillColor: CustomTheme.containerColor,
                    ),
                    const SizedBox(height: 20),

                    // Fecha Input (Date Picker)
                    GestureDetector(
                      onTap: () => appointmentProvider.selectDate(context, appointmentProvider.dateController),
                      child: AbsorbPointer(
                        child: CustomInput(
                          controller: appointmentProvider.dateController,
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
                    const SizedBox(height: 20),

                    // Hora Input (Time Picker)
                    GestureDetector(
                      onTap: () => appointmentProvider.selectTime(context, appointmentProvider.timeController),
                      child: AbsorbPointer(
                        child: CustomInput(
                          controller: appointmentProvider.timeController,
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
                    const SizedBox(height: 20),

                    // Prioridad Dropdown
                    DropdownButtonFormField<Priority>(
                      value: appointmentProvider.selectedPrioridad,
                      dropdownColor: CustomTheme.containerColor,
                      decoration: InputDecoration(
                        labelText: 'Prioridad',
                        labelStyle: const TextStyle(color: CustomTheme.lettersColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                      ),
                      items: Priority.values.map((Priority value) {
                        return DropdownMenuItem<Priority>(
                          value: value,
                          child: Text(value.name, style: const TextStyle(color: CustomTheme.lettersColor)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          appointmentProvider.setPrioridad(newValue);
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Tipo Dropdown
                    DropdownButtonFormField<TypeAppointment>(
                      value: appointmentProvider.selectedTipoCita,
                      dropdownColor: CustomTheme.containerColor,
                      decoration: InputDecoration(
                        labelText: 'Tipo',
                        labelStyle: const TextStyle(color: CustomTheme.lettersColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                      ),
                      items: TypeAppointment.values.map((TypeAppointment value) {
                        return DropdownMenuItem<TypeAppointment>(
                          value: value,
                          child: Text(value.name, style: const TextStyle(color: CustomTheme.lettersColor)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          appointmentProvider.setTipoCita(newValue);
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Guardar Datos Button
                    Center(
                      child: CustomButton(
                        height: 60,
                        width: 200,
                        text: 'Guardar Datos',
                        color: CustomTheme.buttonColor,
                        
onPressed: () async {
  final appointment = Appointment(
    name: patient.name, // Get from selected patient
    idPatient: patient.id,
    reason: appointmentProvider.reasonController.text,
    date: appointmentProvider.dateController.text,
    time: appointmentProvider.timeController.text,
    type: appointmentProvider.selectedTipoCita.name,
    priority: appointmentProvider.selectedPrioridad.name,
    status: "no atendida", // Default status
    rescheduleDate: appointmentProvider.reprogramDateController.text.isNotEmpty
        ? appointmentProvider.reprogramDateController.text
        : null,
    rescheduleTime: appointmentProvider.reprogramTimeController.text.isNotEmpty
        ? appointmentProvider.reprogramTimeController.text
        : null,
    createdAt: DateTime.now().toIso8601String(),
  );

  final result = await appointmentProvider.addAppointment(appointment);

  if (!context.mounted) return;
  if (result['success']) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment Saved Successfully!")),
    );

    // **Clear All Input Fields**
    appointmentProvider.reasonController.clear();
    appointmentProvider.dateController.clear();
    appointmentProvider.timeController.clear();
    appointmentProvider.reprogramDateController.clear();
    appointmentProvider.reprogramTimeController.clear();
    
    // **Reset Dropdown Selections**
    appointmentProvider.setPrioridad(Priority.baja); // Set to default priority
    appointmentProvider.setTipoCita(TypeAppointment.consulta); // Set to default type

    Navigator.of(context).pop(); // Go back after saving
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${result['error']}")),
    );
  }
},
                          // Show success message or navigate to another screen
                        
                      ),
                    ),
                    const SizedBox(height: 50),



                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}