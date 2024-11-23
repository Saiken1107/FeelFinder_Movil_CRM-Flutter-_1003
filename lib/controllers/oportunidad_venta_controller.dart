import 'package:feelfinder_mobile/services/oportunidad_venta_servicio.dart';
import 'package:feelfinder_mobile/models/oportunidad_venta.dart';

class OportunidadVentaController {
  final OportunidadVentaServicio _oportunidadVentaServicio =
      OportunidadVentaServicio();

  Future<List<OportunidadVenta>> obtenerOportunidadesVenta() {
    return _oportunidadVentaServicio.obtenerOportunidadesVenta();
  }

  Future<void> crearOportunidadVenta(OportunidadVenta oportunidadVenta) {
    return _oportunidadVentaServicio.crearOportunidadVenta(oportunidadVenta);
  }
}
