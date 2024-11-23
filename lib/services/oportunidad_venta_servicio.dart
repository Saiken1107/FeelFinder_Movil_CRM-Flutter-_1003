import 'dart:convert';
import 'package:feelfinder_mobile/helpers/api_helper.dart';
import 'package:http/http.dart' as http;
import '../models/oportunidad_venta.dart';

class OportunidadVentaServicio {
  final String apiUrl =
      "https://${ApiHelper.baseUrl}/api/oportunidadventa"; // Cambia esta URL según tu configuración

  Future<List<OportunidadVenta>> obtenerOportunidadesVenta() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<OportunidadVenta> oportunidadesVenta =
          body.map((dynamic item) => OportunidadVenta.fromJson(item)).toList();
      return oportunidadesVenta;
    } else {
      throw Exception('Error al cargar las oportunidades de venta');
    }
  }

  Future<OportunidadVenta> obtenerOportunidadVenta(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return OportunidadVenta.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar la oportunidad de venta');
    }
  }

  Future<http.Response> crearOportunidadVenta(
      OportunidadVenta oportunidadVenta) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(oportunidadVenta.toJson()),
    );

    return response;
  }

  Future<http.Response> actualizarOportunidadVenta(
      int id, OportunidadVenta oportunidadVenta) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(oportunidadVenta.toJson()),
    );

    return response;
  }

  Future<http.Response> eliminarOportunidadVenta(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    return response;
  }
}
