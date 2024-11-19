import '../services/quejas_service.dart';

class QuejaController {
  final QuejaService _quejaService = QuejaService();

  // Obtener todas las quejas
  Future<List<Map<String, dynamic>>> obtenerQuejas() async {
    try {
      return await _quejaService.obtenerQuejas();
    } catch (e) {
      print("Error en obtenerQuejas: $e");
      return []; // Retorna lista vacía en caso de error
    }
  }

  // Registrar una nueva queja
  Future<void> registrarQueja(int idUsuarioSolicita, int idUsuarioNecesita,
      String descripcion, int tipo) async {
    try {
      await _quejaService.registrarQueja(
          idUsuarioSolicita, idUsuarioNecesita, descripcion, tipo);
    } catch (e) {
      print("Error en registrarQueja: $e");
      throw Exception('No se pudo registrar la queja');
    }
  }

  // Actualizar una queja existente
  Future<void> actualizarQueja(
      int idQueja, String descripcion, int tipo, int estatus) async {
    try {
      await _quejaService.actualizarQueja(idQueja, descripcion, tipo, estatus);
    } catch (e) {
      print("Error en actualizarQueja: $e");
      throw Exception('No se pudo actualizar la queja');
    }
  }

  // Cambiar el estatus de una queja
  Future<void> cambiarEstatusQueja(int idQueja, int estatus) async {
    try {
      await _quejaService.cambiarEstatusQueja(idQueja, estatus);
    } catch (e) {
      print("Error en cambiarEstatusQueja: $e");
      throw Exception('No se pudo cambiar el estatus de la queja');
    }
  }
}
