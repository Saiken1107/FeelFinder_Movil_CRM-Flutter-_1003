// suscripcion_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class SuscripcionService {
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

  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    final headers = await _getHeaders();
    final Uri uri = ApiHelper.buildUri('/api/cliente');
    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print("Error en obtenerClientes: ${response.body}");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> obtenerPlanes() async {
    final headers = await _getHeaders();
    final Uri uri = ApiHelper.buildUri('/api/planSuscripcion');
    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print("Error en obtenerPlanes: ${response.body}");
      return [];
    }
  }

  Future<void> registrarSuscripcion(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final Uri uri = ApiHelper.buildUri('/api/suscripcion/registrar-suscripcion');

    print("Datos que se envían a la API: $data");
    print("Headers: $headers");

    final response = await client.post(uri, headers: headers, body: json.encode(data));

    if (response.statusCode != 200) {
      throw Exception('Error al registrar la suscripción: ${response.body}');
    } else {
      print("Suscripción registrada con éxito en la API.");
    }
  }

  Future<void> actualizarSuscripcion(int id, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final Uri uri = ApiHelper.buildUri('/api/suscripcion/$id/actualizar');

    final response = await client.put(uri, headers: headers, body: json.encode(data));

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la suscripción');
    }
  }

  Future<void> eliminarSuscripcion(int id) async {
    final headers = await _getHeaders();
    final Uri uri = ApiHelper.buildUri('/api/suscripcion/$id/eliminar');

    final response = await client.delete(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la suscripción');
    }
  }
}
