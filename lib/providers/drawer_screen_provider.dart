import 'package:feelfinder_mobile/views/screens/drawer_pages/home_page.dart';
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
      
      case CustomScreensEnum.ventasPage:
        // currentScreen = const UsuarioPage();
        _currentString = "Usuario";
        _currentActions = [];
        break;

      case CustomScreensEnum.clientesPage:
        // currentScreen = const MateriasPage();
        _currentString = "Materias";
        _currentActions = [];
        break;

      case CustomScreensEnum.cotizacionesPage:
        // currentScreen = const GruposPage();
        _currentString = "Grupos";
        _currentActions = [];
        break;

      case CustomScreensEnum.quejasPage:
        // currentScreen = const HorariosPage();
        _currentString = "Horarios";
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

enum CustomScreensEnum { homePage, ventasPage, clientesPage, cotizacionesPage, quejasPage}
