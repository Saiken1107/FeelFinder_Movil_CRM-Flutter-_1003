// pago_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class PagoService {
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

  Future<List<Map<String, dynamic>>> obtenerPagos() async {
    final headers = await _getHeaders();
    final Uri uri = ApiHelper.buildUri('/api/pago');
    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print("Error en obtenerPagos: ${response.body}");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> obtenerSuscripciones() async {
    final headers = await _getHeaders();
    final Uri uri = ApiHelper.buildUri('/api/suscripcion');
    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print("Error en obtenerSuscripciones: ${response.body}");
      return [];
    }
  }

  Future<void> registrarPago(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final Uri uri = ApiHelper.buildUri('/api/pago/registrar-pago');

    final response =
        await client.post(uri, headers: headers, body: json.encode(data));

    if (response.statusCode != 200) {
      throw Exception('Error al registrar el pago');
    }
  }

  Future<void> actualizarPago(int id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final Uri uri = ApiHelper.buildUri('/api/pago/$id/actualizar');

    final response =
        await client.put(uri, headers: headers, body: json.encode(data));

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el pago');
    }
  }

  Future<void> eliminarPago(int id) async {
    final headers = await _getHeaders();
    final Uri uri = ApiHelper.buildUri('/api/pago/$id/eliminar');

    final response = await client.delete(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el pago');
    }
  }
}
