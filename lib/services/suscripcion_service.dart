// suscripcion_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class SuscripcionService {
  final String baseUrl = 'http://192.168.100.7/api/suscripcion';

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

  Future<List<Map<String, dynamic>>> obtenerSuscripciones() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar las suscripciones');
    }
  }

  Future<void> insertarSuscripcion(int clienteId, int planId, DateTime fechaInicio) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/registrar-suscripcion'),
      headers: headers,
      body: json.encode({'clienteId': clienteId, 'planId': planId, 'fechaDeInicio': fechaInicio.toIso8601String()}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al insertar suscripción');
    }
  }

  Future<void> modificarSuscripcion(int id, String estado) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/$id/actualizar'),
      headers: headers,
      body: json.encode({'estado': estado}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar suscripción');
    }
  }

  Future<void> eliminarSuscripcion(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/$id/eliminar'), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar suscripción');
    }
  }
}
