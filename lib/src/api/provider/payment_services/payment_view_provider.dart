import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/payment_services/payment_view_service.dart';

class ViewPaymentProvider extends ChangeNotifier {
  final ViewPaymentService _paymentService = ViewPaymentService();
  List<dynamic> _payments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get payments => _payments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getPayments(String patientId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _payments = await _paymentService.fetchPayments(patientId);
    } catch (error) {
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
