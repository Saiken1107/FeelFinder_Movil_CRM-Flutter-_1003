import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/api_helper.dart';

class EmpresaService {
  final http.Client client = http.Client();

  // Definimos los headers de la solicitud (sin token)
  Map<String, String> headers = {
    'Content-Type': 'application/json', // Solo Content-Type
  };

  // Obtener todas las empresas
  Future<List<Map<String, dynamic>>> obtenerEmpresas() async {
    try {
      final Uri uri = ApiHelper.buildUri('/api/Empresa/todas');
      print("obtenerEmpresas: $uri");

      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("obtenerEmpresas respuesta: ${response.body}");
        List<Map<String, dynamic>> empresas =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        return empresas;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Error al cargar las empresas');
      }
    } catch (e) {
      print("Exception en obtenerEmpresas: $e");
      return [];
    }
  }

  // Registrar una nueva empresa
  Future<void> registrarEmpresa(String nombre, String direccion,
      String telefono, String correo, String nombreCliente) async {
    try {
      final Uri uri = ApiHelper.buildUri('/api/empresa/registrar');

      final body = json.encode({
        'nombreCliente': nombre,
        'nombreEmpresa': nombreCliente,
        'direccion': direccion,
        'telefono': telefono,
        'correo': correo,
        'estatus': 1, // Por defecto activa
      });

      final response = await client.post(uri, headers: headers, body: body);
    } catch (e) {
      print("Exception en registrarEmpresa: $e");
      throw Exception('No se pudo registrar la empresa');
    }
  }

  // Actualizar una empresa existente
  Future<void> actualizarEmpresa(int id, String nombre, String direccion,
      String telefono, String correo, String nombreCliente, int status) async {
    try {
      final Uri uri = ApiHelper.buildUri('/api/empresa/actualizar-datos/$id');

      final body = json.encode({
        'id': id,
        'NombreCliente': nombre,
        'NombreEmpresa': nombreCliente,
        'direccion': direccion,
        'telefono': telefono,
        'correo': correo,
        "estatus": status
      });

      final response = await client.put(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al actualizar empresa: ${response.body}");
        throw Exception('Error al actualizar la empresa');
      }
    } catch (e) {
      print("Exception en actualizarEmpresa: $e");
      throw Exception('No se pudo actualizar la empresa');
    }
  }

  // Cambiar el estado de una empresa
  Future<void> cambiarEstatusEmpresa(int idEmpresa, int estatus) async {
    try {
      final Uri uri =
          ApiHelper.buildUri('/api/empresa/$idEmpresa/cambiar-estatus');

      final body = json.encode({
        'estatus': estatus,
      });

      final response = await client.put(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al cambiar estado de empresa: ${response.body}");
        throw Exception('Error al cambiar el estado de la empresa');
      }
    } catch (e) {
      print("Exception en cambiarEstatusEmpresa: $e");
      throw Exception('No se pudo cambiar el estado de la empresa');
    }
  }
}
