 import'package:flutter/material.dart';
 import 'package:fl_chart/fl_chart.dart';
 import'package:app_herbal_flutter/src/theme/default.dart';  
  
  Widget buildGraphPaymentsContainer(String title, double payments, double remaining) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
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
                  barRods: [BarChartRodData(toY: payments, color: CustomTheme.primaryColor, width: 25)],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [BarChartRodData(toY: remaining, color: CustomTheme.secondaryColor, width: 25)],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }