import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';

class CustomCalendarDraft extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomCalendarDraft({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  CustomCalendarDraftState createState() => CustomCalendarDraftState();
}

class CustomCalendarDraftState extends State<CustomCalendarDraft> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.fillColor,
      body: Center(
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: CustomTheme.containerColor,
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
          child: CalendarTimeline(
            initialDate: selectedDate,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
              widget.onDateSelected(date);
            },
            leftMargin: 20,
            monthColor: Colors.white70,
            dayColor: Colors.white,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.blueAccent,
            //dotsColor: Colors.white70,
            selectableDayPredicate: (date) => true,
          ),
        ),
      ),
    );
  }
}
