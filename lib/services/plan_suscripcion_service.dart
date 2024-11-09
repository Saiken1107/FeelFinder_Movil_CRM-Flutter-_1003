// plan_suscripcion_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class PlanSuscripcionService {
  final String baseUrl = 'http://your_api_url/api/planSuscripcion';

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

  Future<List<Map<String, dynamic>>> obtenerPlanes() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar los planes de suscripción');
    }
  }

  Future<void> insertarPlan(String nombre, double precio, int duracionMeses) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/registrar-plan'),
      headers: headers,
      body: json.encode({'nombre': nombre, 'precio': precio, 'duracionMeses': duracionMeses}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al insertar plan de suscripción');
    }
  }

  Future<void> modificarPlan(int id, String nombre, double precio) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/$id/actualizar'),
      headers: headers,
      body: json.encode({'nombre': nombre, 'precio': precio}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar plan de suscripción');
    }
  }

  Future<void> eliminarPlan(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/$id/eliminar'), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar plan de suscripción');
    }
  }
}
