import 'package:app_herbal_flutter/src/functions/build%20dashboard%20graphs/appointments_graph.dart';
import 'package:app_herbal_flutter/src/functions/build%20dashboard%20graphs/text_containers.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/components/custom_container.dart';

import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/dashboard_provider/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
@override
void initState() {
  super.initState();
  Future.delayed(Duration.zero, () {
    if (!mounted) return; // to avoid troubles using Build context with async functions

    final provider = Provider.of<DashboardProvider>(context, listen: false);
    provider.loadCitasData();
    provider.loadAbonosData();
  });
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.fillColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // First row: Citas (Appointments)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomContainer(
                        height: 250,
                        child: buildTextNumberContainer(
                          "Total Citas Atendidas",
                          provider.totalAttended,
                          "No atendidas",
                          provider.totalNotAttended,
                        ),
                      ),
                      CustomContainer(
                        height: 250,
                        child: buildGraphAappointmentsContainer(
                          "Historial de citas",
                          provider.totalAttended,
                          provider.totalNotAttended,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Second row: Abonos (Payments)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomContainer(
                        height: 250,
                        child: buildTextNumberContainer(
                          "Total de abonos",
                          provider.totalPayments,
                          "Abonos pendientes",
                          provider.totalRemaining,
                        ),
                      ),
                      CustomContainer(
                        height: 250,
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
    );
  }

}