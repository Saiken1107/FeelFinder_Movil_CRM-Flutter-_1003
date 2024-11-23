import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class ListaPreciosService {
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

  // Obtener todas las listas de precios
  Future<List<Map<String, dynamic>>> obtenerListasPrecios() async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/listaPrecios');
      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Error al cargar las listas de precios');
      }
    } catch (e) {
      print("Exception in obtenerListasPrecios: $e");
      return [];
    }
  }

  // Obtener una lista de precios por ID
  Future<Map<String, dynamic>> obtenerListaPreciosPorId(int id) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/listaPrecios/$id');
      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        throw Exception('Error al obtener la lista de precios');
      }
    } catch (e) {
      print("Exception in obtenerListaPreciosPorId: $e");
      throw Exception('No se pudo obtener la lista de precios');
    }
  }

  // Crear una nueva lista de precios
  Future<void> crearListaPrecios(Map<String, dynamic> listaPrecios) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/listaPrecios');

      final response = await client.post(uri, headers: headers, body: json.encode(listaPrecios));

      if (response.statusCode != 201) {
        throw Exception('Error al crear la lista de precios');
      }
    } catch (e) {
      print("Exception in crearListaPrecios: $e");
      throw Exception('No se pudo crear la lista de precios');
    }
  }

  // Actualizar una lista de precios existente
  Future<void> actualizarListaPrecios(int id, Map<String, dynamic> listaPrecios) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/listaPrecios/$id');

      final response = await client.put(uri, headers: headers, body: json.encode(listaPrecios));

      if (response.statusCode != 204) {
        throw Exception('Error al actualizar la lista de precios');
      }
    } catch (e) {
      print("Exception in actualizarListaPrecios: $e");
      throw Exception('No se pudo actualizar la lista de precios');
    }
  }

  // Eliminar una lista de precios
  Future<void> eliminarListaPrecios(int id) async {
    try {
      final headers = await _getHeaders();
      final Uri uri = ApiHelper.buildUri('/api/listaPrecios/$id');

      final response = await client.delete(uri, headers: headers);

      if (response.statusCode != 204) {
        throw Exception('Error al eliminar la lista de precios');
      }
    } catch (e) {
      print("Exception in eliminarListaPrecios: $e");
      throw Exception('No se pudo eliminar la lista de precios');
    }
  }
}
