import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../helpers/api_helper.dart';

class QuejaService {
  final http.Client client = http.Client();
// Definimos los headers de la solicitud (sin token)
  Map<String, String> headers = {
    'Content-Type': 'application/json', // Solo Content-Type
  };

  // Obtener todas las quejas
  Future<List<Map<String, dynamic>>> obtenerQuejas() async {
    try {
      // Construir la URL completa de la API
      final Uri uri = ApiHelper.buildUri('/api/Queja/todas');
      print("obtenerQuejas: $uri");
      // Aquí asumimos que 'client' y 'headers' están previamente definidos en tu clase
      final response = await http.get(uri,
          headers:
              headers); // Suponiendo que 'client' y 'headers' son correctos

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        print("obtenerQuejas respuesta: $response.body");
        // Si la respuesta es 200 OK, decodificar el cuerpo JSON en una lista de mapas
        List<Map<String, dynamic>> quejas =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        // Aquí podrías realizar algún procesamiento adicional si es necesario
        return quejas;
      } else if (response.statusCode == 404) {
        // Si la respuesta es 404, significa que no hay quejas, retornamos una lista vacía
        return [];
      } else {
        // Si ocurrió otro error, lanzamos una excepción
        throw Exception('Error al cargar las quejas');
      }
    } catch (e) {
      // Capturar cualquier excepción y mostrar el error https://authapi90320241027235706.azurewebsites.net/api/account/login

      print("Exception en obtenerQuejas: $e");
      return []; // Retorna una lista vacía si ocurre un error
    }
  }

  // Registrar una nueva queja
  Future<void> registrarQueja(int idUsuarioSolicita, int idUsuarioNecesita,
      String descripcion, int tipo) async {
    try {
      final Uri uri = ApiHelper.buildUri('/api/queja/registrar');

      final body = json.encode({
        'id': 0,
        'idUsuarioSolicita': idUsuarioSolicita,
        'idUsuarioNecesita': idUsuarioNecesita,
        'descripcion': descripcion,
        'tipo': tipo,
        "estatus": 1,
      });

      final response = await client.post(uri, headers: headers, body: body);

      if (response.statusCode != 201) {
        print("Error al registrar queja: ${response.body}");
        throw Exception('Error al registrar la queja ${response.body}');
      }
    } catch (e) {
      print("Exception in registrarQueja: $e");
      throw Exception('No se pudo registrar la queja');
    }
  }

  // Actualizar una queja existente
  Future<void> actualizarQueja(int id, String descripcion, int tipo,
      int estatus, idUsuarioSolicita, idUsuarioNecesita) async {
    try {
      final Uri uri = ApiHelper.buildUri('/api/queja/actualizar/$id');

      final body = json.encode({
        "id": id,
        "idUsuarioSolicita": idUsuarioSolicita,
        "idUsuarioNecesita": idUsuarioNecesita,
        'descripcion': descripcion,
        'tipo': tipo,
        'estatus': estatus,
      });

      final response = await client.put(uri, headers: headers, body: body);

      if (response.statusCode != 204) {
        print("Error al actualizar queja: ${response.body}");
        throw Exception('Error al actualizar la queja');
      }
    } catch (e) {
      print("Exception in actualizarQueja: $e");
      throw Exception('No se pudo actualizar la queja');
    }
  }

  // Cambiar el estatus de una queja
  Future<void> cambiarEstatusQueja(int idQueja, int estatus) async {
    try {
      final Uri uri = ApiHelper.buildUri('/api/queja/$idQueja/cambiar-estatus');

      final body = json.encode({
        'estatus': estatus,
      });

      final response = await client.put(uri, headers: headers, body: body);

      if (response.statusCode != 200) {
        print("Error al cambiar estatus de queja: ${response.body}");
        throw Exception('Error al cambiar el estatus de la queja');
      }
    } catch (e) {
      print("Exception in cambiarEstatusQueja: $e");
      throw Exception('No se pudo cambiar el estatus de la queja');
    }
  }

  // Obtener todas las quejas
  Future<List<Map<String, dynamic>>> obtenerProfesional() async {
    try {
      // Construir la URL completa de la API
      final Uri uri = ApiHelper.buildUri('/api/Queja/profesionales');
      print("obtenerQuejas: $uri");
      // Aquí asumimos que 'client' y 'headers' están previamente definidos en tu clase
      final response = await http.get(uri,
          headers:
              headers); // Suponiendo que 'client' y 'headers' son correctos

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        print("obtenerProfesionales respuesta: $response.body");
        // Si la respuesta es 200 OK, decodificar el cuerpo JSON en una lista de mapas
        List<Map<String, dynamic>> quejas =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        // Aquí podrías realizar algún procesamiento adicional si es necesario
        return quejas;
      } else if (response.statusCode == 404) {
        // Si la respuesta es 404, significa que no hay quejas, retornamos una lista vacía
        return [];
      } else {
        // Si ocurrió otro error, lanzamos una excepción
        throw Exception('Error al cargar las profesionales');
      }
    } catch (e) {
      // Capturar cualquier excepción y mostrar el error https://authapi90320241027235706.azurewebsites.net/api/account/login

      print("Exception en obtenerProfesionales: $e");
      return []; // Retorna una lista vacía si ocurre un error
    }
  }
}
