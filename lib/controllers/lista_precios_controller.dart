
import 'package:feelfinder_mobile/models/lista_precios.dart';
import 'package:feelfinder_mobile/services/lista_precios_service.dart';


class ListaPreciosController {
  final ListaPreciosServicio _listaPreciosServicio = ListaPreciosServicio();

  Future<List<ListaPrecios>> obtenerListasPrecios() {
    return _listaPreciosServicio.obtenerListasPrecios();
  }

  Future<void> crearListaPrecios(ListaPrecios listaPrecios) {
    return _listaPreciosServicio.crearListaPrecios(listaPrecios);
  }
}
