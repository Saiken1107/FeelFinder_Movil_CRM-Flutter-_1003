// price_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class PriceService {
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

  Future<List<Map<String, dynamic>>> obtenerPrecios() async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/precio');
      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return []; // Retorna una lista vacía si no encuentra precios
      } else {
        throw Exception('Error al cargar los precios');
      }
    } catch (e) {
      print("Exception in obtenerPrecios: $e");
      return []; // Retorna lista vacía si ocurre un error
    }
  }

  Future<void> registrarPrecio(
      String planType,
      double planPrice,
      String company,
      int licenseQuantity,
      int contractTime,
      double finalPrice) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/precio/registrar-precio');

      final body = json.encode({
        'planType': planType,
        'planPrice': planPrice,
        'company': company,
        'licenseQuantity': licenseQuantity,
        'contractTime': contractTime,
        'finalPrice': finalPrice,
      });

      final response = await client.post(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al registrar precio: ${response.body}");
        throw Exception('Error al registrar precio');
      }
    } catch (e) {
      print("Exception in registrarPrecio: $e");
      throw Exception('No se pudo registrar el precio');
    }
  }

  Future<void> actualizarPrecio(
      String id,
      String planType,
      double planPrice,
      String company,
      int licenseQuantity,
      int contractTime,
      double finalPrice) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/precio/$id/actualizar');

      final body = json.encode({
        'planType': planType,
        'planPrice': planPrice,
        'company': company,
        'licenseQuantity': licenseQuantity,
        'contractTime': contractTime,
        'finalPrice': finalPrice,
      });

      final response = await client.put(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al actualizar precio: ${response.body}");
        throw Exception('Error al actualizar precio');
      }
    } catch (e) {
      print("Exception in actualizarPrecio: $e");
      throw Exception('No se pudo actualizar el precio');
    }
  }

  Future<void> eliminarPrecio(String id) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/precio/$id/eliminar');

      final response = await client.delete(uri, headers: headers);

      if (response.statusCode != 200) {
        print("Error al eliminar precio: ${response.body}");
        throw Exception('Error al eliminar precio');
      }
    } catch (e) {
      print("Exception in eliminarPrecio: $e");
      throw Exception('No se pudo eliminar el precio');
    }
  }
}
