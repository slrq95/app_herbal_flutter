import 'package:app_herbal_flutter/src/functions/appointment%20fuctions/cancel_appointment.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/appointement_services/appointment_provider.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});
 @override
  AppointmentPageState createState() => AppointmentPageState();
}

class AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
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
                            width: 90,
                            height: 40,
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
                      height: 60.0,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E), // Background color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.person, color: Colors.white), // User icon
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Nombre del Paciente", // Placeholder, replace with real data
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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
                    DropdownButtonFormField<Prioridad>(
                      value: appointmentProvider.selectedPrioridad,
                      dropdownColor: CustomTheme.containerColor,
                      decoration: InputDecoration(
                        labelText: 'Prioridad',
                        labelStyle: const TextStyle(color: CustomTheme.lettersColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                      ),
                      items: Prioridad.values.map((Prioridad value) {
                        return DropdownMenuItem<Prioridad>(
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
                    DropdownButtonFormField<TipoCita>(
                      value: appointmentProvider.selectedTipoCita,
                      dropdownColor: CustomTheme.containerColor,
                      decoration: InputDecoration(
                        labelText: 'Tipo',
                        labelStyle: const TextStyle(color: CustomTheme.lettersColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                      ),
                      items: TipoCita.values.map((TipoCita value) {
                        return DropdownMenuItem<TipoCita>(
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
                        onPressed: () {
                          // Implement API call to save data
                        },
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Reprogramar Cita Input (Date Picker)
                    GestureDetector(
                      onTap: () => appointmentProvider.selectDate(context, appointmentProvider.reprogramDateController),
                      child: AbsorbPointer(
                        child: CustomInput(
                          controller: appointmentProvider.reprogramDateController,
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

                    // Reprogramar Hora Input (Time Picker)
                    GestureDetector(
                      onTap: () => appointmentProvider.selectTime(context, appointmentProvider.reprogramTimeController),
                      child: AbsorbPointer(
                        child: CustomInput(
                          controller: appointmentProvider.reprogramTimeController,
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
                    const SizedBox(height: 15),

                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          height: 60,
                          width: 140,
                          text: 'Cancelar Cita',
                          color: CustomTheme.secondaryColor,
                          onPressed: () {
                            showCancelAppointmentConfirmationDialog(context);
                          },
                        ),
                        CustomButton(
                          height: 60,
                          width: 140,
                          text: 'Reprogramar Cita',
                          color: CustomTheme.primaryColor,
                          onPressed: () {
                            appointmentProvider.reprogramDateTime();
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
      ),
    );
  }
}