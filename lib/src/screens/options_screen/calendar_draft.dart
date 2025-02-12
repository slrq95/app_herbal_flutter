import 'package:app_herbal_flutter/src/components/custom_calendar/custom_calendar_draft.dart';
import 'package:flutter/material.dart';


class ScreenCalendar extends StatefulWidget {
  const ScreenCalendar({super.key});

  @override
  _ScreenCalendarState createState() => _ScreenCalendarState();
}

class _ScreenCalendarState extends State<ScreenCalendar> {
  DateTime selectedDate = DateTime.now();

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          "Calendar View",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// FIX: Wrap CustomCalendar with a constrained height
          SizedBox(
            height: 160, // Define a fixed height
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
            "Selected Date: ${selectedDate.toLocal()}".split(' ')[0],
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
