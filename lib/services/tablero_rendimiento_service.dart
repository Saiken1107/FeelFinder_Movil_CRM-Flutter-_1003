import 'dart:convert';
import 'package:feelfinder_mobile/helpers/api_helper.dart';
import 'package:http/http.dart' as http;
import '../models/tablero_rendimiento.dart';

class TableroRendimientoServicio {
  final String apiUrl =
      "https://${ApiHelper.baseUrl}/api/tablerorendimiento"; // Cambia esta URL según tu configuración


  Future<TableroRendimiento> obtenerTableroRendimiento() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return TableroRendimiento.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el tablero de rendimiento');
    }
  }
}
