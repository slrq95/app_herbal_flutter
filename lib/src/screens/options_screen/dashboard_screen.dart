import 'package:app_herbal_flutter/src/functions/build_dashboard_graphs/appointments_graph.dart';
import 'package:app_herbal_flutter/src/functions/build_dashboard_graphs/text_containers.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/components/custom_container.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/provider/dashboard_provider/dashboard_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial dashboard data
    
    Future.microtask(() {
      
      final provider = Provider.of<DashboardProvider>(context, listen: false);
      provider.loadDashboardData();
    });
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedRange != null) {
      String startDate = DateFormat('yyyy-MM-dd').format(pickedRange.start);
      String endDate = DateFormat('yyyy-MM-dd').format(pickedRange.end);

      if (!context.mounted) return;
      final provider = Provider.of<DashboardProvider>(context, listen: false);
      
      // Avoid unnecessary calls if dates are the same
      if (startDate != provider.totalPayments.toString() || endDate != provider.totalRemaining.toString()) {
        provider.loadDashboardData(startDate: startDate, endDate: endDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.fillColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 190.0),
            child: Consumer<DashboardProvider>(
              builder: (context, provider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomContainer(
                          height: 450,
                          width: 350,
                          child: buildTextNumberContainer(
                            "Total Citas Atendidas",
                            provider.totalAttended,
                            "No Atendidas",
                            provider.totalNotAttended,
                          ),
                        ),
                        const SizedBox(width: 50),
                        CustomContainer(
                          height: 450,
                          width: 350,
                          child: buildGraphAappointmentsContainer(
                            "Historial de Citas",
                            provider.totalAttended,
                            provider.totalNotAttended,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomContainer(
                          height: 450,
                          width: 350,
                          child: buildTextNumberContainer(
                            "Total de Abonos",
                            provider.totalPayments,
                            "Abonos Pendientes",
                            provider.totalRemaining,
                          ),
                        ),
                        const SizedBox(width: 50),
                        CustomContainer(
                          height: 450,
                          width: 350,
                          child: buildGraphAappointmentsContainer(
                            "Historial de Abonos",
                            provider.totalPayments,
                            provider.totalRemaining,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        final provider = Provider.of<DashboardProvider>(context, listen: false);
                        provider.loadDashboardData();
                      },
                      child: const Text("Fetch Payments"),
                    ),
                    FloatingActionButton(
          onPressed: () => _showDateRangePicker(context),
          child: const Icon(Icons.date_range),
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
