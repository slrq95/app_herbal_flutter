import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class FirebaseAuthService {
  final String apiKey;
  FirebaseAuthService({required this.apiKey});
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(json.decode(response.body)['error']['message']);
    }
  }
}


bool isTokenExpired(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) {
      return true; // Invalid token
    }
    final payload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    final expiry = payload['exp'] as int?; // Expiry time in seconds since epoch
    if (expiry == null) {
      return true; // Invalid token payload
    }
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return expiry < currentTimestamp; // Token is expired if current time > expiry
  } catch (_) {
    return true; // Any error means the token is invalid
  }
}

class AuthTokenStorage {
  static const String _tokenKey = 'authToken';
  // Save token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  // Token reception using sharedpreferences to local manangement of token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  // Checking token existency
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null;
  }
  // Remove token for signout
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  Future<void> checkAuthStatus(BuildContext context) async {
    final authTokenStorage = AuthTokenStorage();
    final token = await authTokenStorage.getToken();

    if (token != null && !isTokenExpired(token)) {
      // Valid token
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Token is missing or expired, navigate to login page
      await authTokenStorage.removeToken(); // Ensure stale token is removed
      Navigator.of(context).pushReplacementNamed('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => checkAuthStatus(context));

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}