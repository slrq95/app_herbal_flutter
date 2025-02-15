import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';// Import the custom calendar
import 'package:app_herbal_flutter/src/theme/default.dart';

class PantallaCalendario extends StatefulWidget {
  const PantallaCalendario({super.key});

  @override
  State<PantallaCalendario> createState() => _PantallaCalendarioState();
}

class _PantallaCalendarioState extends State<PantallaCalendario> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.fillColor, // Set the background color to #121212

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
                    color: CustomTheme.onprimaryColor,
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

            ],
          ),
        ],
      ),
    );
  }
}
