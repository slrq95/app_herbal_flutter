import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/dashboard_provider/dashboard_service.dart';

class DashboardProvider with ChangeNotifier {
  double _totalAttended = 0;
  double _totalNotAttended = 0;
  double _totalPayments = 0;
  double _totalRemaining = 0;
  double _totalTreatmentPrices = 0;

  String? _lastStartDate;
  String? _lastEndDate;

  final DashboardService _dashboardService = DashboardService();

  double get totalAttended => _totalAttended;
  double get totalNotAttended => _totalNotAttended;
  double get totalPayments => _totalPayments;
  double get totalRemaining => _totalRemaining;
  double get totalTreatmentPrices => _totalTreatmentPrices;

Future<void> loadDashboardData({dynamic startDate, dynamic endDate}) async {
  try {
    _lastStartDate = startDate ?? _lastStartDate;
    _lastEndDate = endDate ?? _lastEndDate;

    // Use Future.wait to load data concurrently
    await Future.wait([
      _loadCitasData(),
      _loadPaymentsData(),
      _loadTreatmentPricesData(),
    ]);
      // Calculate the remaining balance
      _calculateRemainingBalance();

      // Notify listeners once data has been loaded
      notifyListeners();
  } catch (e) {
    debugPrint("Error loading dashboard data: $e");
  }
}

Future<void> _loadCitasData() async {
  try {
    final data = await _dashboardService.fetchAppointmentStats(
      startDate: _lastStartDate,
      endDate: _lastEndDate,
    );

    _totalAttended = (data['atendida'] ?? 0).toDouble();
    _totalNotAttended = (data['no_atendida'] ?? 0).toDouble();
  } catch (e) {
    debugPrint("Error loading citas data: $e");
  }
}

Future<void> _loadPaymentsData() async {
  try {
    final totalPayments = await _dashboardService.fetchPaymentsByDate(
      startDate: _lastStartDate,
      endDate: _lastEndDate,
    );

    _totalPayments = totalPayments; // Directly set the sum
  } catch (e) {
    debugPrint("Error loading payments data: $e");
  }
}

Future<void> _loadTreatmentPricesData() async {
  try {
    final totalPrices = await _dashboardService.fetchTreatmentPricesByDate(
      startDate: _lastStartDate,
      endDate: _lastEndDate,
    );
      // Log the fetched value
    debugPrint("Fetched treatment prices: $totalPrices");
    _totalTreatmentPrices = totalPrices; // Directly set the sum
  } catch (e) {
    debugPrint("Error loading treatment prices data: $e");
  }
}

  void _calculateRemainingBalance() {
    _totalRemaining = _totalTreatmentPrices - _totalPayments;
  }

}
