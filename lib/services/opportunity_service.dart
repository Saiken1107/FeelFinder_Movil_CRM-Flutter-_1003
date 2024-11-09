// opportunity_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class OpportunityService {
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

  Future<List<Map<String, dynamic>>> obtenerOportunidades() async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/oportunidad');
      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return []; // Retorna una lista vacía si no encuentra oportunidades
      } else {
        throw Exception('Error al cargar las oportunidades');
      }
    } catch (e) {
      print("Exception in obtenerOportunidades: $e");
      return []; // Retorna lista vacía si ocurre un error
    }
  }

  Future<void> registrarOportunidad(
      String cliente, int cantidadLicencia, String status) async {
    try {
      final headers = await _getHeaders();
      final Uri uri =
          ApiHelper.buildUri('/api/oportunidad/registrar-oportunidad');

      final body = json.encode({
        'cliente': cliente,
        'cantidadLicencia': cantidadLicencia,
        'status': status,
      });

      final response = await client.post(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al registrar oportunidad: ${response.body}");
        throw Exception('Error al registrar oportunidad');
      }
    } catch (e) {
      print("Exception in registrarOportunidad: $e");
      throw Exception('No se pudo registrar la oportunidad');
    }
  }

  Future<void> actualizarOportunidad(
      String id, String cliente, int cantidadLicencia, String status) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/oportunidad/$id/actualizar');

      final body = json.encode({
        'cliente': cliente,
        'cantidadLicencia': cantidadLicencia,
        'status': status,
      });

      final response = await client.put(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al actualizar oportunidad: ${response.body}");
        throw Exception('Error al actualizar oportunidad');
      }
    } catch (e) {
      print("Exception in actualizarOportunidad: $e");
      throw Exception('No se pudo actualizar la oportunidad');
    }
  }

  Future<void> eliminarOportunidad(String id) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/oportunidad/$id/eliminar');

      final response = await client.delete(uri, headers: headers);

      if (response.statusCode != 200) {
        print("Error al eliminar oportunidad: ${response.body}");
        throw Exception('Error al eliminar oportunidad');
      }
    } catch (e) {
      print("Exception in eliminarOportunidad: $e");
      throw Exception('No se pudo eliminar la oportunidad');
    }
  }
}
