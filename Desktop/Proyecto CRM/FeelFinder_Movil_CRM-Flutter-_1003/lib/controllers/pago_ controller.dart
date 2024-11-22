// pago_controller.dart
import '../services/pago_service.dart';

class PagoController {
  final PagoService _pagoService = PagoService();

  Future<List<Map<String, dynamic>>> obtenerPagos() async {
    return await _pagoService.obtenerPagos();
  }

  Future<List<Map<String, dynamic>>> obtenerSuscripciones() async {
    return await _pagoService.obtenerSuscripciones();
  }

  Future<void> registrarPago(Map<String, dynamic> data) async {
    await _pagoService.registrarPago(data);
  }

  Future<void> actualizarPago(int id, Map<String, dynamic> data) async {
    await _pagoService.actualizarPago(id, data);
  }

  Future<void> eliminarPago(int id) async {
    await _pagoService.eliminarPago(id);
  }
}
