import 'package:feelfinder_mobile/providers/drawer_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// final Box _boxLogin = Hive.box("login");
// String _stringNombre = "";

class _HomePageState extends State<HomePage> {
  //final ejemploPeticionController = EjemploHTTPGetController();
  //UsuarioController usuarioController = UsuarioController();

  void _refreshData() async {
    // final data = await usuarioController.obtenerUnUsuario(_boxLogin.get("userId"));

    setState(() {
      // _stringNombre = data[0]['nombre'];
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
                    "Bienvenido",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: MediaQuery.of(context).size.height / 3.8,
                ),
                children: [
                  BotonMenu(
                    texto: "Ventas",
                    icono: Icons.book,
                    onTap: () {
                      // Provider.of<DrawerScreenProvider>(context, listen: false).changeCurrentScreen(CustomScreensEnum.materiasPage);
                    },
                  ),
                  BotonMenu(
                    texto: "Clientes",
                    icono: Icons.group,
                    onTap: () {
                      // Provider.of<DrawerScreenProvider>(context, listen: false).changeCurrentScreen(CustomScreensEnum.gruposPage);
                    },
                  ),
                  BotonMenu(
                    texto: "Cotizaciones",
                    icono: Icons.lock_clock,
                    onTap: () {
                      // Provider.of<DrawerScreenProvider>(context, listen: false).changeCurrentScreen(CustomScreensEnum.horariosPage);
                    },
                  ),
                  BotonMenu(
                    texto: "Quejas",
                    icono: Icons.person,
                    onTap: () {
                      Provider.of<DrawerScreenProvider>(context, listen: false)
                          .changeCurrentScreen(CustomScreensEnum.quejasPage);
                    },
                  ),
                ],
              ),
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
        onPressed: onTap, //Aqui se inserta la funcion recibida como argumento
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
