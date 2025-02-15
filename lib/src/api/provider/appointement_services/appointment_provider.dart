import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Priority { alta, media, baja }
enum TypeAppointment { consulta, reconsulta, procedimiento }
enum Status{atendida,noatendida,cancelada}
class AppointmentProvider extends ChangeNotifier {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController reprogramDateController = TextEditingController();
  final TextEditingController reprogramTimeController = TextEditingController();

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
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
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      notifyListeners(); // Notify UI of changes
    }
  }

  Future<void> selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      controller.text = pickedTime.format(context);
      notifyListeners();
    }
  }

  void reprogramDateTime() {
    dateController.text = reprogramDateController.text;
    timeController.text = reprogramTimeController.text;
    notifyListeners();
  }
    // Selected values
  Priority _selectedPrioridad = Priority.alta;
  TypeAppointment _selectedTipoCita = TypeAppointment.consulta;

  // Getters
  Priority get selectedPrioridad => _selectedPrioridad;
  TypeAppointment get selectedTipoCita => _selectedTipoCita;

  // Setters
  void setPrioridad(Priority priority) {
    _selectedPrioridad = priority;
    notifyListeners();
  }

  void setTipoCita(TypeAppointment typeAppointment) {
    _selectedTipoCita = typeAppointment;
    notifyListeners();
  }
}
