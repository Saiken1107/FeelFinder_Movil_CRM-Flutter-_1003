// quote_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class QuoteService {
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
      } else if (response.statusCode == 404) {
        return []; // Retorna una lista vacía si no encuentra cotizaciones
      } else {
        throw Exception('Error al cargar las cotizaciones');
      }
    } catch (e) {
      print("Exception in obtenerCotizaciones: $e");
      return []; // Retorna lista vacía si ocurre un error
    }
  }

  Future<void> registrarCotizacion(String cliente, int cantidadLicencia,
      String tipoPlan, double precioPlan) async {
    try {
      final headers = await _getHeaders();
      final Uri uri =
          ApiHelper.buildUri('/api/cotizacion/registrar-cotizacion');

      final body = json.encode({
        'cliente': cliente,
        'cantidadLicencia': cantidadLicencia,
        'tipoPlan': tipoPlan,
        'precioPlan': precioPlan,
      });

      final response = await client.post(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al registrar cotización: ${response.body}");
        throw Exception('Error al registrar cotización');
      }
    } catch (e) {
      print("Exception in registrarCotizacion: $e");
      throw Exception('No se pudo registrar la cotización');
    }
  }

  Future<void> actualizarCotizacion(String id, String cliente,
      int cantidadLicencia, String tipoPlan, double precioPlan) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/cotizacion/$id/actualizar');

      final body = json.encode({
        'cliente': cliente,
        'cantidadLicencia': cantidadLicencia,
        'tipoPlan': tipoPlan,
        'precioPlan': precioPlan,
      });

      final response = await client.put(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al actualizar cotización: ${response.body}");
        throw Exception('Error al actualizar cotización');
      }
    } catch (e) {
      print("Exception in actualizarCotizacion: $e");
      throw Exception('No se pudo actualizar la cotización');
    }
  }

  Future<void> eliminarCotizacion(String id) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/cotizacion/$id/eliminar');

      final response = await client.delete(uri, headers: headers);

      if (response.statusCode != 200) {
        print("Error al eliminar cotización: ${response.body}");
        throw Exception('Error al eliminar cotización');
      }
    } catch (e) {
      print("Exception in eliminarCotizacion: $e");
      throw Exception('No se pudo eliminar la cotización');
    }
  }
}
