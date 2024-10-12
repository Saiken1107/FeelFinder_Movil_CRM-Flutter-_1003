import 'package:flutter/material.dart';

class CotizacionesPage extends StatefulWidget {
  const CotizacionesPage({super.key});

  @override
  State<CotizacionesPage> createState() => _CotizacionesPageState();
}


class _CotizacionesPageState extends State<CotizacionesPage> {


  void _refreshData() async {
    

    setState(() {

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
