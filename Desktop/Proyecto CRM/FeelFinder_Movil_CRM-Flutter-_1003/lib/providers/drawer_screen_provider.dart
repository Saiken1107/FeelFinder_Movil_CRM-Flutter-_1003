import 'package:feelfinder_mobile/views/screens/drawer_pages/clientes_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/home_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/pagos_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/plan_suscripciones_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/quejas_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/oportunidad_venta_page.dart'
    as OportunidadVentaPage;
import 'package:feelfinder_mobile/views/screens/drawer_pages/lista_precios_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/suscripciones_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/ventas_page.dart';

import 'package:feelfinder_mobile/views/screens/drawer_pages/empresas_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/cotizacion_page.dart';
import 'package:flutter/material.dart';

import '../views/screens/drawer_pages/tablero_rendimiento_page.dart.dart';

class DrawerScreenProvider extends ChangeNotifier {
  late Widget _currentScreen = const HomePage();
  late String _currentString = "Inicio";
  late List<Widget> _currentActions = [];

  Widget get currentScreen => _currentScreen;
  List<Widget> get currentActions => _currentActions;
  String get currentString => _currentString;

  set currentScreen(Widget newScreen) {
    _currentScreen = newScreen;
    notifyListeners();
  }

  void changeCurrentScreen(CustomScreensEnum screen) {
    switch (screen) {
      case CustomScreensEnum.homePage:
        currentScreen = const HomePage();
        _currentString = "Inicio";
        _currentActions = [];
        break;

      /* case CustomScreensEnum.ventasPage:
        currentScreen = const ventasPage();
        _currentString = "Usuario";
        _currentActions = [];
        break;*/

      case CustomScreensEnum.planesSuscripcionPage:
        currentScreen = const PlanesSuscripcionesPage();
        _currentString = "Planes";
        _currentActions = [];
        break;

      case CustomScreensEnum.suscripcionesPage:
        currentScreen = const SuscripcionesPage();
        _currentString = "Suscripciones";
        _currentActions = [];
        break;

      case CustomScreensEnum.pagosPage:
        currentScreen = const PagosPage();
        _currentString = "Pagos";
        _currentActions = [];
        break;

      case CustomScreensEnum.clientesPage:
        currentScreen = const ClientesPage();
        _currentString = "Clientes";
        _currentActions = [];
        break;

      case CustomScreensEnum.cotizacionPage:
        currentScreen = CotizacionPage();
        _currentString = "Cotizaciones";
        _currentActions = [];
        break;

      case CustomScreensEnum.quejasPage:
        currentScreen = QuejasPage();
        _currentString = "Quejas";
        _currentActions = [];
        break;

      case CustomScreensEnum.listapreciosPage:
        currentScreen = ListaPreciosPage();
        _currentString = "Precios";
        _currentActions = [];
        break;

      case CustomScreensEnum.tablerorendimientopage:
        currentScreen = TableroRendimientoPage();
        _currentString = "Dashboard";
        _currentActions = [];
        break;

      case CustomScreensEnum.oportunidadventaPage:
        currentScreen = OportunidadVentaPage.OportunidadVentaPage();
        _currentString = "Oportunidades";
        _currentActions = [];
        break;

      case CustomScreensEnum.empresasPage:
        currentScreen = EmpresasPage();
        _currentString = "Empresas";
        _currentActions = [];
        break;
      default:
        currentScreen = const HomePage();
        _currentString = "Inicio";
        _currentActions = [];

        break;
    }
  }
}

enum CustomScreensEnum {
  homePage,

  planesSuscripcionPage,
  suscripcionesPage,
  pagosPage,
  clientesPage,
  cotizacionPage,
  oportunidadventaPage,
  quejasPage,
  tablerorendimientopage,
  listapreciosPage,
  oportunidadesPage,
  empresasPage,
  actividadespage
}
