import 'package:feelfinder_mobile/views/screens/drawer_pages/clientes_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/cotizaciones_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/home_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/quejas_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/dashboard_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/oportunidades_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/precios_page.dart';

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

      /*case CustomScreensEnum.ventasPage:
        currentScreen = ventasPage();
        _currentString = "Usuario";
        _currentActions = [];
        break;*/

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

      case CustomScreensEnum.preciosPage:
        currentScreen = const PreciosPage();
        _currentString = "Precios";
        _currentActions = [];
        break;

      case CustomScreensEnum.dashboardPage:
        currentScreen = const DashboardPage();
        _currentString = "Dashboard";
        _currentActions = [];
        break;

      case CustomScreensEnum.oportunidadesPage:
        currentScreen = const OportunidadesPage();
        _currentString = "Oportunidades";
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
  ventasPage,
  clientesPage,
  cotizacionesPage,
  quejasPage,
  dashboardPage,
  preciosPage,
  oportunidadesPage,
}
