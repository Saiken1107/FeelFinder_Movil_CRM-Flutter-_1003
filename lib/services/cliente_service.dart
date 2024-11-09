// cliente_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class ClienteService {
  final String baseUrl = 'http://your_api_url/api/cliente';

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

  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar los clientes');
    }
  }

  Future<void> insertarCliente(String nombre, String correo) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/registrar-cliente'),
      headers: headers,
      body: json.encode({'nombre': nombre, 'correoElectronico': correo}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al insertar cliente');
    }
  }

  Future<void> modificarCliente(int id, String nombre) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/$id/actualizar'),
      headers: headers,
      body: json.encode({'nombre': nombre}),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar cliente');
    }
  }

  Future<void> eliminarCliente(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/$id/eliminar'), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar cliente');
    }
  }
}
