// plan_suscripcion_controller.dart
import '../services/plan_suscripcion_service.dart';

class PlanSuscripcionController {
  final PlanSuscripcionService _planSuscripcionService = PlanSuscripcionService();

  Future<List<Map<String, dynamic>>> obtenerPlanes() {
    return _planSuscripcionService.obtenerPlanes();
  }

  Future<void> insertarPlan(String nombre, double precio, int duracionMeses) {
    return _planSuscripcionService.insertarPlan(nombre, precio, duracionMeses);
  }

  Future<void> modificarPlan(int id, String nombre, double precio) {
    return _planSuscripcionService.modificarPlan(id, nombre, precio);
  }

  Future<void> eliminarPlan(int id) {
    return _planSuscripcionService.eliminarPlan(id);
  }
}
