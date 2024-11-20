import 'dart:convert';
import 'package:feelfinder_mobile/helpers/api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  final String _loginEndpoint = "api/account/login";

  Future<String> login(String email, String password) async {
    final client = http.Client();

    final response = await client.post(
      Uri.https(ApiHelper.baseUrl, _loginEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['isSuccess'] == true) {
        final token = responseData['token'];
        final expiration = DateTime.now().add(Duration(seconds: 3600)); // 1 hora

        var box = await Hive.openBox('auth');
        await box.put('token', token);
        await box.put('tokenExpiration', expiration.toIso8601String());

        return "Login exitoso!";
      } else {
        return responseData['message'] ?? "Error de login.";
      }
    } else {
      return "Error al iniciar sesión: ${response.statusCode}";
    }
  }

  Future<String?> getToken() async {
    var box = await Hive.openBox('auth');
    final token = box.get('token');
    final expiration = box.get('tokenExpiration');

    if (expiration != null && DateTime.parse(expiration).isBefore(DateTime.now())) {
      return null; // El token ha expirado
    }
    return token;
  }

  Future<void> logout() async {
    var box = await Hive.openBox('auth');
    await box.delete('token');
    await box.delete('tokenExpiration');
  }
}
