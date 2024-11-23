import 'package:feelfinder_mobile/services/cotizacion_service.dart';
import 'package:feelfinder_mobile/models/cotizacion.dart';

class CotizacionController {
  final CotizacionServicio _cotizacionServicio = CotizacionServicio();

  Future<List<Cotizacion>> obtenerCotizaciones() {
    return _cotizacionServicio.obtenerCotizaciones();
  }

  Future<void> crearCotizacion(Cotizacion cotizacion) {
    return _cotizacionServicio.crearCotizacion(cotizacion);
  }
}
