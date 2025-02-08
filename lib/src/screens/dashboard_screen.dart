import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/components/custom_container.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double total_attended = 0;
  double total_not_attended = 0;
  double total_payments = 0;
  double total_remaining = 0;

  @override
  void initState() {
    super.initState();
    _loadCitasData();
    _loadAbonosData();
  }

  // Load data for Citas (Appointments)
  void _loadCitasData() {
    setState(() {
      total_attended = 30;     // Replace with API or DB call
      total_not_attended = 10; // Replace with API or DB call
    });
  }

  // Load data for Abonos (Payments)
  void _loadAbonosData() {
    setState(() {
      total_payments = 6000;        // Replace with API or DB call
      total_remaining = 5000;   // Replace with API or DB call
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.fillColor,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // First row: Citas (Appointments)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomContainer(
                  child: _buildTextNumberContainer(
                      "Total Citas Atendidas", total_attended,
                      "No atendidas", total_not_attended),
                ),
                CustomContainer(
                  child: _buildGraphCitasContainer("Historial de citas"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Second row: Abonos (Payments)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomContainer(
                  child: _buildTextNumberContainer(
                      "Total de abonos", total_payments,
                      "Abonos pendientes", total_remaining),
                ),
                CustomContainer(
                  child: _buildGraphAbonosContainer("Historial de abonos"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Graph for Citas
  Widget _buildGraphCitasContainer(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 1,
                  barRods: [BarChartRodData(toY: total_attended, color: CustomTheme.primaryColor, width: 25)],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [BarChartRodData(toY: total_not_attended, color: CustomTheme.secondaryColor, width: 25)],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Graph for Abonos
  Widget _buildGraphAbonosContainer(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 1,
                  barRods: [BarChartRodData(toY: total_payments, color: CustomTheme.primaryColor, width: 25)],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [BarChartRodData(toY: total_remaining, color: CustomTheme.secondaryColor, width: 25)],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Text & Number Container
  Widget _buildTextNumberContainer(String text1, double number1, String text2, double number2) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text1,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        Text(
          number1.toInt().toString(),
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text2,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        Text(
          number2.toInt().toString(),
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
