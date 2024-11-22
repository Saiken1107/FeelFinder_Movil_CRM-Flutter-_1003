import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/services/tablero_rendimiento_service.dart';
import 'package:feelfinder_mobile/models/tablero_rendimiento.dart';

class TableroRendimientoPage extends StatefulWidget {
  @override
  _TableroRendimientoPaginaState createState() =>
      _TableroRendimientoPaginaState();
}

class _TableroRendimientoPaginaState extends State<TableroRendimientoPage> {
  final TableroRendimientoServicio _tableroRendimientoServicio =
      TableroRendimientoServicio();
  late Future<TableroRendimiento> _tableroRendimiento;

  @override
  void initState() {
    super.initState();
    _tableroRendimiento =
        _tableroRendimientoServicio.obtenerTableroRendimiento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tablero de Rendimiento'),
      ),
      body: FutureBuilder<TableroRendimiento>(
        future: _tableroRendimiento,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No hay datos disponibles'));
          } else {
            final tablero = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Leads Concretados: ${tablero?.leadsConcretados ?? 'N/A'}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Leads Cerrados: ${tablero?.leadsCerrados ?? 'N/A'}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text(
                      'Tasa de Conversión: ${tablero?.tasaConversion ?? 'N/A'}%',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
