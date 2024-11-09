// plan_suscripcion_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class PlanSuscripcionService {
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

  // Obtener todos los planes
  Future<List<Map<String, dynamic>>> obtenerPlanes() async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/planSuscripcion');
      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Error al cargar los planes de suscripción');
      }
    } catch (e) {
      print("Exception in obtenerPlanes: $e");
      return [];
    }
  }

  // Registrar un nuevo plan
  Future<void> registrarPlan(String nombre, double precio, String descripcion, int duracionMeses) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/planSuscripcion/registrar-plan');

      final body = json.encode({
        'nombre': nombre,
        'precio': precio,
        'descripcion': descripcion,
        'duracionMeses': duracionMeses,
      });

      final response = await client.post(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al registrar plan: ${response.body}");
        throw Exception('Error al registrar el plan de suscripción');
      }
    } catch (e) {
      print("Exception in registrarPlan: $e");
      throw Exception('No se pudo registrar el plan de suscripción');
    }
  }

  // Actualizar un plan existente
  Future<void> actualizarPlan(int id, String nombre, double? precio, String? descripcion, int? duracionMeses) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/planSuscripcion/$id/actualizar');

      final body = json.encode({
        'nombre': nombre,
        'precio': precio,
        'descripcion': descripcion,
        'duracionMeses': duracionMeses,
      });

      final response = await client.put(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al actualizar plan: ${response.body}");
        throw Exception('Error al actualizar el plan de suscripción');
      }
    } catch (e) {
      print("Exception in actualizarPlan: $e");
      throw Exception('No se pudo actualizar el plan de suscripción');
    }
  }

  // Eliminar un plan
  Future<void> eliminarPlan(int id) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/planSuscripcion/$id/eliminar');

      final response = await client.delete(uri, headers: headers);

      if (response.statusCode != 200) {
        print("Error al eliminar plan: ${response.body}");
        throw Exception('Error al eliminar el plan de suscripción');
      }
    } catch (e) {
      print("Exception in eliminarPlan: $e");
      throw Exception('No se pudo eliminar el plan de suscripción');
    }
  }
}
