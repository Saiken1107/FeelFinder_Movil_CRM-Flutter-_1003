// suscripcion_controller.dart
import '../services/suscripcion_service.dart';

class SuscripcionController {
  final SuscripcionService _suscripcionService = SuscripcionService();

  Future<List<Map<String, dynamic>>> obtenerSuscripciones() {
    return _suscripcionService.obtenerSuscripciones();
  }

  Future<void> insertarSuscripcion(int clienteId, int planId, DateTime fechaInicio) {
    return _suscripcionService.insertarSuscripcion(clienteId, planId, fechaInicio);
  }

  Future<void> modificarSuscripcion(int id, String estado) {
    return _suscripcionService.modificarSuscripcion(id, estado);
  }

  Future<void> eliminarSuscripcion(int id) {
    return _suscripcionService.eliminarSuscripcion(id);
  }
}
