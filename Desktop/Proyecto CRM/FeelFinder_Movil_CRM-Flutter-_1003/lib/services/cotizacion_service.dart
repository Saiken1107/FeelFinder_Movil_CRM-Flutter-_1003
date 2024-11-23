// FeelFinder_Movil_CRM-Flutter-_1003/lib/servicios/cotizacion_servicio.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cotizacion.dart';

class CotizacionServicio {
  final String apiUrl =
      "http://localhost:5000/api/cotizacion"; // Cambia esta URL según tu configuración

  Future<List<Cotizacion>> obtenerCotizaciones() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Cotizacion> cotizaciones =
          body.map((dynamic item) => Cotizacion.fromJson(item)).toList();
      return cotizaciones;
    } else {
      throw Exception('Error al cargar las cotizaciones');
    }
  }

  Future<Cotizacion> obtenerCotizacion(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return Cotizacion.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar la cotizacion');
    }
  }

  Future<http.Response> crearCotizacion(Cotizacion cotizacion) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cotizacion.toJson()),
    );

    return response;
  }

  Future<http.Response> actualizarCotizacion(
      int id, Cotizacion cotizacion) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cotizacion.toJson()),
    );

    return response;
  }

  Future<http.Response> eliminarCotizacion(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    return response;
  }
}
