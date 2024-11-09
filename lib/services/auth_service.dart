// auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class AuthService {
  final String loginUrl = 'http://192.168.100.7/api/account/login';

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final refreshToken = data['refreshToken'];

        // Almacenar el token en Hive
        var box = await Hive.openBox('login');
        await box.put('token', token);
        await box.put('refreshToken', refreshToken);

        return true;
      } else {
        print('Login failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<void> logout() async {
    var box = await Hive.openBox('login');
    await box.delete('token');
    await box.delete('refreshToken');
  }

  Future<String?> getToken() async {
    var box = await Hive.openBox('login');
    return box.get('token');
  }
}
