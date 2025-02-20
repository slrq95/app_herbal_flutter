import 'package:flutter/material.dart';

class TreatmentViewProvider extends ChangeNotifier {
  final Map<int, String> _notes = {}; // Store notes per treatment ID

  String getNote(int treatmentId) => _notes[treatmentId] ?? '';

  void updateNote(int treatmentId, String note) {
    _notes[treatmentId] = note;
    notifyListeners();
  }
}
