import 'package:feelfinder_mobile/providers/drawer_screen_provider.dart';
import 'package:feelfinder_mobile/views/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final Box boxLogin0 = Hive.box("login");

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 235, 215, 252),
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary,
            ],
            stops: const [0.015, 0.5, 1],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LayoutBuilder(
                    //   builder:
                    //       (BuildContext context, BoxConstraints constraints) {
                    //     return Image.asset(
                    //       'assets/icons/1024.png',
                    //       height: constraints.maxHeight / 2,
                    //     );
                    //   },
                    // ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/images/Feelfinder2.png',
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
            DrawerTile(
                title: 'Inicio',
                icon: Icons.home_filled,
                onTap: () {
                  Provider.of<DrawerScreenProvider>(context, listen: false)
                      .changeCurrentScreen(CustomScreensEnum.homePage);
                  Navigator.pop(context);
                }),
            DrawerTile(
                title: 'Ventas',
                icon: Icons.home_filled,
                onTap: () {
                  Provider.of<DrawerScreenProvider>(context, listen: false)
                      .changeCurrentScreen(CustomScreensEnum.ventasPage);
                  Navigator.pop(context);
                }),
            DrawerTile(
                title: 'Clientes',
                icon: Icons.book,
                onTap: () {
                  Provider.of<DrawerScreenProvider>(context, listen: false)
                      .changeCurrentScreen(CustomScreensEnum.clientesPage);
                  Navigator.pop(context);
                }),
            DrawerTile(
                title: 'Cotizaciones',
                icon: Icons.contact_phone,
                onTap: () {
                  Provider.of<DrawerScreenProvider>(context, listen: false)
                      .changeCurrentScreen(CustomScreensEnum.cotizacionesPage);
                  Navigator.pop(context);
                }),
            DrawerTile(
                title: 'Reclamos',
                icon: Icons.group,
                onTap: () {
                  Provider.of<DrawerScreenProvider>(context, listen: false)
                      .changeCurrentScreen(CustomScreensEnum.quejasPage);
                  Navigator.pop(context);
                }),
            DrawerTile(
                title: 'Precios',
                icon: Icons.price_change,
                onTap: () {
                  Provider.of<DrawerScreenProvider>(context, listen: false)
                      .changeCurrentScreen(CustomScreensEnum.preciosPage);
                  Navigator.pop(context);
                }),
            DrawerTile(
                title: 'Oportunidades',
                icon: Icons.handshake_rounded,
                onTap: () {
                  Provider.of<DrawerScreenProvider>(context, listen: false)
                      .changeCurrentScreen(CustomScreensEnum.oportunidadesPage);
                  Navigator.pop(context);
                }),
            DrawerTile(
              title: 'Cerrar Sesión',
              icon: Icons.logout,
              onTap: () {
                final Box boxLogin = Hive.box("login");
                boxLogin.clear();
                boxLogin.put("loginStatus", false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const Login();
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: Colors.white,
      onTap: onTap,
      horizontalTitleGap: 0,
      leading: Icon(icon, color: Colors.white),
      title: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(title,
              style: const TextStyle(fontSize: 13, color: Colors.white))),
    );
  }
}
