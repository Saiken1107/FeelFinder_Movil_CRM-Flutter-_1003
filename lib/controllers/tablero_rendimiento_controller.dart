import 'package:feelfinder_mobile/services/tablero_rendimiento_service.dart';
import 'package:feelfinder_mobile/models/tablero_rendimiento.dart';

class TableroRendimientoController {
  final TableroRendimientoServicio _tableroRendimientoServicio =
      TableroRendimientoServicio();

  Future<TableroRendimiento> obtenerTableroRendimiento() {
    return _tableroRendimientoServicio.obtenerTableroRendimiento();
  }
}
