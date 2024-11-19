// pago_controller.dart
import '../services/pago_service.dart';

class PagoController {
  final PagoService _pagoService = PagoService();

  Future<List<Map<String, dynamic>>> obtenerPagos() {
    return _pagoService.obtenerPagos();
  }

  Future<void> insertarPago(double cantidad, DateTime fechaPago, int suscripcionId) {
    return _pagoService.insertarPago(cantidad, fechaPago, suscripcionId);
  }

  Future<void> modificarPago(int id, double cantidad) {
    return _pagoService.modificarPago(id, cantidad);
  }

  Future<void> eliminarPago(int id) {
    return _pagoService.eliminarPago(id);
  }
}
