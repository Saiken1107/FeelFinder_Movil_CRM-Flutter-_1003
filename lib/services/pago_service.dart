// pago_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class PagoService {
  final String baseUrl = 'http://your_api_url/api/pago';

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

  Future<List<Map<String, dynamic>>> obtenerPagos() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar los pagos');
    }
  }

  Future<void> insertarPago(double cantidad, DateTime fechaPago, int suscripcionId) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/registrar-pago'),
      headers: headers,
      body: json.encode({'cantidad': cantidad, 'fechaDePago': fechaPago.toIso8601String(), 'suscripcionId': suscripcionId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al insertar pago');
    }
  }

  Future<void> modificarPago(int id, double cantidad) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/$id/actualizar'),
      headers: headers,
      body: json.encode({'cantidad': cantidad}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar pago');
    }
  }

  Future<void> eliminarPago(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/$id/eliminar'), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar pago');
    }
  }
}
