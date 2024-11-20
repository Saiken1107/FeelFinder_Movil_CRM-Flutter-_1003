class ApiHelper {
  static const String baseUrl = '192.168.100.14:5000'; // Cambia a la IP y el puerto correctos de tu servidor
  
  // Método para construir la URI completa para las rutas
  static Uri buildUri(String path, [Map<String, String>? queryParameters]) {
    return Uri.https(baseUrl, path, queryParameters);
  }
}
