// FeelFinder_Movil_CRM-Flutter-_1003/lib/servicios/lista_precios_servicio.dart
import 'dart:convert';
import 'package:feelfinder_mobile/models/lista_precios.dart';
import 'package:http/http.dart' as http;

class ListaPreciosServicio {
  final String apiUrl =
      "http://localhost:5000/api/listaprecios"; // Cambia esta URL según tu configuración

  Future<List<ListaPrecios>> obtenerListasPrecios() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<ListaPrecios> listasPrecios =
          body.map((dynamic item) => ListaPrecios.fromJson(item)).toList();
      return listasPrecios;
    } else {
      throw Exception('Error al cargar las listas de precios');
    }
  }

  Future<ListaPrecios> obtenerListaPrecios(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return ListaPrecios.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar la lista de precios');
    }
  }

  Future<http.Response> crearListaPrecios(ListaPrecios listaPrecios) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(listaPrecios.toJson()),
    );

    return response;
  }

  Future<http.Response> actualizarListaPrecios(
      int id, ListaPrecios listaPrecios) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(listaPrecios.toJson()),
    );

    return response;
  }

  Future<http.Response> eliminarListaPrecios(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    return response;
  }
}
