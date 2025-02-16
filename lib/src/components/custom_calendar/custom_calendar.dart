<<<<<<< HEAD
=======
// ignore_for_file: depend_on_referenced_packages

>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomCalendar({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
<<<<<<< HEAD
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
=======
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends State<CustomCalendar> {
>>>>>>> f4e8f26 (FEAT/FIX/CLINICAL_HISTORY/LOGIN)
  late DateTime selectedDate;
  late List<DateTime> weekDates;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    weekDates = _generateWeekDates(selectedDate);
  }

  List<DateTime> _generateWeekDates(DateTime date) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  void _onDateTap(DateTime date) {
    setState(() {
      selectedDate = date;
      widget.onDateSelected(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Matches your theme
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekDates.map((date) {
          bool isSelected = date.day == selectedDate.day;
          return GestureDetector(
            onTap: () => _onDateTap(date),
            child: Column(
              children: [
                Text(
                  DateFormat.E().format(date), // Short weekday name
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${date.day}",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
