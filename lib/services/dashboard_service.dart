// dashboard_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class DashboardService {
  final http.Client client = http.Client();

  Future<String?> _obtenerToken() async {
    var box = await Hive.openBox('login');
    return box.get('token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _obtenerToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> obtenerResumenDashboard() async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/dashboard/summary');
      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al cargar los datos del dashboard');
      }
    } catch (e) {
      print("Exception in obtenerResumenDashboard: $e");
      throw Exception('No se pudo obtener los datos del dashboard');
    }
  }
}
