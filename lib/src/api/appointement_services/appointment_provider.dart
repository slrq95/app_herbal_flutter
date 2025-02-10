import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Prioridad { alta, media, baja }

enum TipoCita { consulta, reconsulta, procedimiento }
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
  Prioridad _selectedPrioridad = Prioridad.alta;
  TipoCita _selectedTipoCita = TipoCita.consulta;

  // Getters
  Prioridad get selectedPrioridad => _selectedPrioridad;
  TipoCita get selectedTipoCita => _selectedTipoCita;

  // Setters
  void setPrioridad(Prioridad prioridad) {
    _selectedPrioridad = prioridad;
    notifyListeners();
  }

  void setTipoCita(TipoCita tipoCita) {
    _selectedTipoCita = tipoCita;
    notifyListeners();
  }
}
