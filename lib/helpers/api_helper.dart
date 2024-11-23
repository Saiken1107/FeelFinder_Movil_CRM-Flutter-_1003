class ApiHelper {
  static const String baseUrl = '10.0.2.2:5000'; // Cambia a la IP y el puerto correctos de tu servidor
  
  // Método para construir la URI completa para las rutas
  static Uri buildUri(String path, [Map<String, String>? queryParameters]) {
    return Uri.https(baseUrl, path, queryParameters);
  }
}
