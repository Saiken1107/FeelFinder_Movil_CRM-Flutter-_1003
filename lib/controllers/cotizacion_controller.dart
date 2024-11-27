// cotizacion_controller.dart
import '../services/cotizacion_service.dart';

class CotizacionController {
  final CotizacionService _cotizacionService = CotizacionService();

  Future<List<Map<String, dynamic>>> obtenerCotizaciones() async {
    try {
      return await _cotizacionService.obtenerCotizaciones();
    } catch (e) {
      print("Error en obtenerCotizaciones: $e");
      return [];
    }
  }

  Future<void> registrarCotizacion(Map<String, dynamic> cotizacionData) async {
    try {
      await _cotizacionService.registrarCotizacion(cotizacionData);
    } catch (e) {
      print("Error en registrarCotizacion: $e");
      throw Exception("No se pudo registrar la cotización");
    }
  }

  Future<void> actualizarCotizacion(int id, Map<String, dynamic> cotizacionData) async {
    try {
      await _cotizacionService.actualizarCotizacion(id, cotizacionData);
    } catch (e) {
      print("Error en actualizarCotizacion: $e");
      throw Exception("No se pudo actualizar la cotización");
    }
  }

  Future<void> eliminarCotizacion(int id) async {
    try {
      await _cotizacionService.eliminarCotizacion(id);
    } catch (e) {
      print("Error en eliminarCotizacion: $e");
      throw Exception("No se pudo eliminar la cotización");
    }
  }
}
