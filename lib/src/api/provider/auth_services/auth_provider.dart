import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/api/provider/auth_services/auth_dio.dart';

class DioAuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  final AuthDio _authDio = AuthDio();

  DioAuthProvider() {
    _loadToken(); // Load token on initialization
  }

  Future<void> _loadToken() async {
    final token = await _authDio.loadToken();
    _isAuthenticated = token != null && !_authDio.isTokenExpired(token);
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Notify UI that loading has started

    final success = await _authDio.signIn(email, password);
    if (success) {
      _isAuthenticated = true;
      notifyListeners(); // Notify UI about successful login
    } else {
      _isLoading = false;
      notifyListeners(); // Notify UI about failed login
    }
    return success;
  }

Future<void> logout() async {
  _isLoading = true; // Start loading
  notifyListeners();

  await _authDio.logout();

  _isAuthenticated = false;
  _isLoading = false; // ✅ Ensure loading is stopped after logout
  notifyListeners();
}
}
