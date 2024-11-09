// cliente_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class ClienteService {
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

  // Obtener todos los clientes
  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/cliente');
      final response = await client.get(uri, headers: headers);
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return []; // Retorna una lista vacía si no encuentra clientes
      } else {
        throw Exception('Error al cargar los clientes');
      }
    } catch (e) {
      print("Exception in obtenerClientes: $e");
      return []; // Retorna lista vacía si ocurre un error
    }
  }

  // Registrar un nuevo cliente
  Future<void> registrarCliente(String correo, String nombre, String apellido) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/cliente/registrar-cliente');
      
      final body = json.encode({
        'correoElectronico': correo,
        'nombre': nombre,
        'apellido': apellido,
      });
      
      final response = await client.post(uri, headers: headers, body: body);
      
      if (response.statusCode != 200) {
        print("Error al registrar cliente: ${response.body}");
        throw Exception('Error al registrar cliente');
      }
    } catch (e) {
      print("Exception in registrarCliente: $e");
      throw Exception('No se pudo registrar el cliente');
    }
  }

  // Actualizar un cliente existente
  Future<void> actualizarCliente(int id, String correo, String nombre, String apellido) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/cliente/$id/actualizar');
      
      final body = json.encode({
        'correoElectronico': correo,
        'nombre': nombre,
        'apellido': apellido,
      });
      
      final response = await client.put(uri, headers: headers, body: body);
      
      if (response.statusCode != 200) {
        print("Error al actualizar cliente: ${response.body}");
        throw Exception('Error al actualizar cliente');
      }
    } catch (e) {
      print("Exception in actualizarCliente: $e");
      throw Exception('No se pudo actualizar el cliente');
    }
  }

  // Eliminar un cliente
  Future<void> eliminarCliente(int id) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/cliente/$id/eliminar');
      
      final response = await client.delete(uri, headers: headers);
      
      if (response.statusCode != 200) {
        print("Error al eliminar cliente: ${response.body}");
        throw Exception('Error al eliminar cliente');
      }
    } catch (e) {
      print("Exception in eliminarCliente: $e");
      throw Exception('No se pudo eliminar el cliente');
    }
  }
}
