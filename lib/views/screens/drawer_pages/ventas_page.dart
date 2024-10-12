import 'package:flutter/material.dart';

class VentasPage extends StatefulWidget {
  const VentasPage({super.key});

  @override
  State<VentasPage> createState() => _VentasPageState();
}


class _VentasPageState extends State<VentasPage> {
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
        child: Text("Ventas")
      )
    );
  }
}
