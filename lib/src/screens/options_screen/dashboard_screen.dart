import 'package:app_herbal_flutter/src/functions/build_dashboard_graphs/appointments_graph.dart';
import 'package:app_herbal_flutter/src/functions/build_dashboard_graphs/text_containers.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/components/custom_container.dart';

import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/provider/dashboard_provider/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: CustomTheme.fillColor,
      body: Center( // Centers the entire column
        child: Padding(
          padding: const EdgeInsets.only(bottom: 190.0), 
          // Reduced padding
          child: Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
                children: [
                  // First row: Citas (Appointments)
                  Row(
                    mainAxisSize: MainAxisSize.min, // Reduces width to wrap children
                    mainAxisAlignment: MainAxisAlignment.center, // Centers horizontally
                    children: [
                      CustomContainer(
                        height: 450,
                        width: 350, // Adjusted width
                        child: buildTextNumberContainer(
                          "Total Citas Atendidas",
                          provider.totalAttended,
                          "No atendidas",
                          provider.totalNotAttended,
                        ),
                      ),
                      const SizedBox(width: 50), // Reduce space between containers
                      CustomContainer(
                        height: 450,
                        width: 350, // Adjusted width
                        child: buildGraphAappointmentsContainer(
                          "Historial de citas",
                          provider.totalAttended,
                          provider.totalNotAttended,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50), // Reduce space between rows

                  // Second row: Abonos (Payments)
                  Row(
                    mainAxisSize: MainAxisSize.min, 
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomContainer(
                        height: 450,
                        width: 350, 
                        child: buildTextNumberContainer(
                          "Total de abonos",
                          provider.totalPayments,
                          "Abonos pendientes",
                          provider.totalRemaining,
                        ),
                      ),
                      const SizedBox(width: 50),
                      CustomContainer(
                        height: 450,
                        width: 350,
                        child: buildGraphAappointmentsContainer(
                          "Historial de abonos",
                          provider.totalPayments,
                          provider.totalRemaining,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}

}