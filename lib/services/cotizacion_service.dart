// cotizacion_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class CotizacionService {
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

  Future<List<Map<String, dynamic>>> obtenerCotizaciones() async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/cotizacion');
      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Error al obtener cotizaciones");
      }
    } catch (e) {
      print("Exception in obtenerCotizaciones: $e");
      return [];
    }
  }

  Future<void> registrarCotizacion(Map<String, dynamic> cotizacionData) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/cotizacion');
      final response = await client.post(
        uri,
        headers: headers,
        body: json.encode(cotizacionData),
      );

      if (response.statusCode != 201) {
        throw Exception("Error al registrar la cotización");
      }
    } catch (e) {
      print("Exception in registrarCotizacion: $e");
      throw Exception("No se pudo registrar la cotización");
    }
  }

  Future<void> actualizarCotizacion(int id, Map<String, dynamic> cotizacionData) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/cotizacion/$id');
      final response = await client.put(
        uri,
        headers: headers,
        body: json.encode(cotizacionData),
      );

      if (response.statusCode != 204) {
        throw Exception("Error al actualizar la cotización");
      }
    } catch (e) {
      print("Exception in actualizarCotizacion: $e");
      throw Exception("No se pudo actualizar la cotización");
    }
  }

  Future<void> eliminarCotizacion(int id) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/cotizacion/$id');
      final response = await client.delete(uri, headers: headers);

      if (response.statusCode != 204) {
        throw Exception("Error al eliminar la cotización");
      }
    } catch (e) {
      print("Exception in eliminarCotizacion: $e");
      throw Exception("No se pudo eliminar la cotización");
    }
  }
}
