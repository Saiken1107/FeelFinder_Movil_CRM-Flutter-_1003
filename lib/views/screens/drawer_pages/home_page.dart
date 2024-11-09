import 'package:feelfinder_mobile/providers/drawer_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isAuthenticated = false;
  String _userName = '';

  void _refreshData() async {
    // final data = await usuarioController.obtenerUnUsuario(_boxLogin.get("userId"));

    setState(() {
      // _stringNombre = data[0]['nombre'];
      _userName = 'Usuario'; // Asigna el nombre del usuario aquí
      _isAuthenticated = true; // Actualiza el estado de autenticación
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 2, spreadRadius: 1, color: Colors.blueGrey)
                ],
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Bienvenido, $_userName",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isAuthenticated ? DashboardPage() : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class BotonMenu extends StatelessWidget {
  final Function()? onTap;
  final IconData? icono;
  final String? texto;

  const BotonMenu({super.key, this.icono, this.onTap, this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icono, //Dato del icono
              size: 50,
            ),
            Text(
              texto!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  shadows: [Shadow(color: Colors.white, offset: Offset(0, 0))]),
            )
          ],
        ),
      ),
    );
  }
}
