class ApiHelper {
  // static const String baseUrl = '192.168.3.126:5000'; // Cambia a la IP y el puerto correctos de tu servidor
  static const String baseUrl = 'authapi90320241205125233.azurewebsites.net'; // Cambia a la IP y el puerto correctos de tu servidor
  
  // Método para construir la URI completa para las rutas
  static Uri buildUri(String path, [Map<String, String>? queryParameters]) {
    return Uri.https(baseUrl, path, queryParameters);
  }
}
