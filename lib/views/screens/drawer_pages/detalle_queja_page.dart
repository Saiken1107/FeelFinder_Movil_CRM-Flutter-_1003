import 'package:flutter/material.dart';
import 'quejas_page.dart';

class DetalleQuejaPage extends StatelessWidget {
  final Queja queja;

  DetalleQuejaPage({required this.queja});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de la Queja"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              "Usuario: ${queja.idUsuarioNecesita}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Estatus: ${queja.estatus}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Tipo de Suscripción: ${queja.idUsuarioSolicita}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Descripción:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              queja.descripcion,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
