// plan_suscripcion_controller.dart
import '../services/plan_suscripcion_service.dart';

class PlanSuscripcionController {
  final PlanSuscripcionService _planService = PlanSuscripcionService();

  Future<List<Map<String, dynamic>>> obtenerPlanes() async {
    try {
      return await _planService.obtenerPlanes();
    } catch (e) {
      print("Error en obtenerPlanes: $e");
      return [];
    }
  }

  Future<void> registrarPlan(String nombre, double precio, String descripcion, int duracionMeses) async {
    try {
      await _planService.registrarPlan(nombre, precio, descripcion, duracionMeses);
    } catch (e) {
      print("Error en registrarPlan: $e");
      throw Exception('No se pudo registrar el plan de suscripción');
    }
  }

  Future<void> actualizarPlan(int id, String nombre, double? precio, String? descripcion, int? duracionMeses) async {
    try {
      await _planService.actualizarPlan(id, nombre, precio, descripcion, duracionMeses);
    } catch (e) {
      print("Error en actualizarPlan: $e");
      throw Exception('No se pudo actualizar el plan de suscripción');
    }
  }

  Future<void> eliminarPlan(int id) async {
    try {
      await _planService.eliminarPlan(id);
    } catch (e) {
      print("Error en eliminarPlan: $e");
      throw Exception('No se pudo eliminar el plan de suscripción');
    }
  }
}
