// dashboard_controller.dart
import '../services/dashboard_service.dart';

class DashboardController {
  final DashboardService _dashboardService = DashboardService();

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final data = await _dashboardService.obtenerResumenDashboard();

      // Procesa los datos si es necesario
      final totalCotizaciones = data['totalCotizaciones'];
      final totalSuscripciones = data['totalSuscripciones'];
      final suscripcionesPorPlan = List<Map<String, dynamic>>.from(data['suscripcionesPorPlan']);

      return {
        'totalCotizaciones': totalCotizaciones,
        'totalSuscripciones': totalSuscripciones,
        'suscripcionesPorPlan': suscripcionesPorPlan,
      };
    } catch (e) {
      print("Exception in getDashboardData: $e");
      throw Exception('Error al obtener datos procesados del dashboard');
    }
  }
}
