import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/models/cotizacion.dart';
import 'package:feelfinder_mobile/services/cotizacion_service.dart';

class CotizacionPage extends StatefulWidget {
  @override
  _CotizacionPaginaState createState() => _CotizacionPaginaState();
}

class _CotizacionPaginaState extends State<CotizacionPage> {
  final CotizacionServicio _cotizacionServicio = CotizacionServicio();
  late Future<List<Cotizacion>> _cotizaciones;

  @override
  void initState() {
    super.initState();
    _cotizaciones = _cotizacionServicio.obtenerCotizaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cotizaciones'),
      ),
      body: FutureBuilder<List<Cotizacion>>(
        future: _cotizaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(child: Text('No hay cotizaciones disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final cotizacion = snapshot.data![index];
                return ListTile(
                  title: Text(cotizacion.cliente),
                  subtitle: Text(
                      'Descripción: ${cotizacion.descripcion}, Precio: ${cotizacion.precio}'),
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
          // Navegar a la página de creación de cotización
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
