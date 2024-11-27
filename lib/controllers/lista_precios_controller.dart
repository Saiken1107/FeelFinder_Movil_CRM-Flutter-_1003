import '../services/lista_precios_service.dart';

class ListaPreciosController {
  final ListaPreciosService _listaPreciosService = ListaPreciosService();

  Future<List<Map<String, dynamic>>> obtenerListasPrecios() async {
    try {
      return await _listaPreciosService.obtenerListasPrecios();
    } catch (e) {
      print("Error en obtenerListasPrecios: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> obtenerListaPreciosPorId(int id) async {
    try {
      return await _listaPreciosService.obtenerListaPreciosPorId(id);
    } catch (e) {
      print("Error en obtenerListaPreciosPorId: $e");
      throw Exception('Error al obtener la lista de precios');
    }
  }

  Future<void> crearListaPrecios(Map<String, dynamic> listaPrecios) async {
    try {
      await _listaPreciosService.crearListaPrecios(listaPrecios);
    } catch (e) {
      print("Error en crearListaPrecios: $e");
      throw Exception('Error al crear la lista de precios');
    }
  }

  Future<void> actualizarListaPrecios(int id, Map<String, dynamic> listaPrecios) async {
    try {
      await _listaPreciosService.actualizarListaPrecios(id, listaPrecios);
    } catch (e) {
      print("Error en actualizarListaPrecios: $e");
      throw Exception('Error al actualizar la lista de precios');
    }
  }

  Future<void> eliminarListaPrecios(int id) async {
    try {
      await _listaPreciosService.eliminarListaPrecios(id);
    } catch (e) {
      print("Error en eliminarListaPrecios: $e");
      throw Exception('Error al eliminar la lista de precios');
    }
  }
}
