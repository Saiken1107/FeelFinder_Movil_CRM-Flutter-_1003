import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/services/oportunidad_venta_servicio.dart';
import 'package:feelfinder_mobile/models/oportunidad_venta.dart';

class OportunidadVentaPage extends StatefulWidget {
  @override
  _OportunidadVentaPaginaState createState() => _OportunidadVentaPaginaState();
}

class _OportunidadVentaPaginaState extends State<OportunidadVentaPage> {
  final OportunidadVentaServicio _oportunidadVentaServicio =
      OportunidadVentaServicio();
  late Future<List<OportunidadVenta>> _oportunidadesVenta;

  @override
  void initState() {
    super.initState();
    _oportunidadesVenta = _oportunidadVentaServicio.obtenerOportunidadesVenta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oportunidades de Venta'),
      ),
      body: FutureBuilder<List<OportunidadVenta>>(
        future: _oportunidadesVenta,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
            return Center(
                child: Text('No hay oportunidades de venta disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final oportunidadVenta = snapshot.data![index];
                return ListTile(
                  title: Text(oportunidadVenta.nombreCliente),
                  subtitle: Text(
                      'Descripción: ${oportunidadVenta.descripcion}, Valor Estimado: ${oportunidadVenta.valorEstimado}'),
                  onTap: () {
                    // Navegar a la página de detalles
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la página de creación de oportunidad de venta
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
