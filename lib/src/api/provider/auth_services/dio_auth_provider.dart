import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DioAuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final Dio _dio = Dio();
  static const String _tokenKey = 'authToken';
  final String apiKey = dotenv.env['APIKEY'] ?? ''; 
  final String apiEndpoint = dotenv.env['ENDPOINT'] ?? ''; 
  String? _token;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  DioAuthProvider() {
    _loadToken(); // Load token on initialization
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _isAuthenticated = _token != null && !isTokenExpired(_token!);
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Notify UI that loading has started

    try {
      final response = await _dio.post(
        '${apiEndpoint}accounts:signInWithPassword?key=$apiKey',
        data: {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['idToken'];
        await _saveToken(token);
        _isAuthenticated = true;
        notifyListeners(); // Notify UI about successful login
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      print("Login Error: ${e.response?.data}");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading has stopped
    }
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _token = token;
  }

  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final expiry = payload['exp'] as int?;
      if (expiry == null) return true;
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return expiry < currentTimestamp;
    } catch (_) {
      return true;
    }
  }
}

