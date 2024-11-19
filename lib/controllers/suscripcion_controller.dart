// suscripcion_controller.dart
import '../services/suscripcion_service.dart';

class SuscripcionController {
  final SuscripcionService _suscripcionService = SuscripcionService();

  Future<List<Map<String, dynamic>>> obtenerSuscripciones() async {
    return await _suscripcionService.obtenerSuscripciones();
  }

  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    return await _suscripcionService.obtenerClientes();
  }

  Future<List<Map<String, dynamic>>> obtenerPlanes() async {
    return await _suscripcionService.obtenerPlanes();
  }

  Future<void> registrarSuscripcion(Map<String, dynamic> data) async {
    print("Datos que llegan al controlador para registrar: $data");
    await _suscripcionService.registrarSuscripcion(data);
  }

  Future<void> actualizarSuscripcion(int id, Map<String, dynamic> data) async {
    print("Datos que llegan al controlador para actualizar: $data");
    await _suscripcionService.actualizarSuscripcion(id, data);
  }

  Future<void> eliminarSuscripcion(int id) async {
    await _suscripcionService.eliminarSuscripcion(id);
  }
}
