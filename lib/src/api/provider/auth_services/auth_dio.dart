// ignore_for_file: unused_field

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthDio {
  final Dio _dio = Dio();
  static const String _tokenKey = 'authToken';
  final String apiKey = dotenv.env['APIKEY'] ?? ''; 
  final String apiEndpoint = dotenv.env['ENDPOINT'] ?? ''; 
  String? _token;

  Future<bool> signIn(String email, String password) async {
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
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      debugPrint("Login Error: ${e.response?.data}");
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _token = null;
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

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
