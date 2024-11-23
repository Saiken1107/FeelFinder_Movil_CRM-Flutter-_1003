import 'package:feelfinder_mobile/views/screens/drawer_pages/clientes_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/cotizaciones_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/home_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/pagos_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/plan_suscripciones_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/quejas_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/dashboard_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/oportunidades_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/lista_precios_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/suscripciones_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/usuarios_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/ventas_page.dart';

import 'package:feelfinder_mobile/views/screens/drawer_pages/empresas_page.dart';
import 'package:flutter/material.dart';

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

      case CustomScreensEnum.cotizacionesPage:
        currentScreen = const CotizacionesPage();
        _currentString = "Cotizaciones";
        _currentActions = [];
        break;

      case CustomScreensEnum.quejasPage:
        currentScreen = QuejasPage();
        _currentString = "Quejas";
        _currentActions = [];
        break;

      case CustomScreensEnum.usuariosPage:
        currentScreen = UsuariosPage();
        _currentString = "Profesionales";
        _currentActions = [];
        break;

      case CustomScreensEnum.preciosPage:
        currentScreen = ListaPreciosPage();
        _currentString = "Precios";
        _currentActions = [];
        break;

      case CustomScreensEnum.dashboardPage:
        currentScreen = const DashboardPage();
        _currentString = "Dashboard";
        _currentActions = [];
        break;
      case CustomScreensEnum.quejasPage:
        currentScreen = QuejasPage();
        _currentString = "Quejas";
        _currentActions = [];
        break;

      case CustomScreensEnum.tablerorendimientopage:
        currentScreen = DashboardPage();
        _currentString = "Dashboard";
        _currentActions = [];
        break;

      case CustomScreensEnum.oportunidadventaPage:
        currentScreen = OportunidadesPage();
        _currentString = "Oportunidades";
        _currentActions = [];
        break;
      case CustomScreensEnum.oportunidadesPage:
        currentScreen = const OportunidadesPage();
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
  listapreciosPage,
  planesSuscripcionPage,
  suscripcionesPage,
  pagosPage,
  cotizacionPage,
  clientesPage,
  tablerorendimientopage,
  cotizacionesPage,
  oportunidadventaPage,
  quejasPage,
  dashboardPage,
  preciosPage,
  oportunidadesPage,
  usuariosPage,
  empresasPage,
  actividadespage
}
