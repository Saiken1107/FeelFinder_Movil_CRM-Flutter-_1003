import 'package:flutter/material.dart';
import 'nueva_queja_page.dart';
import 'lista_quejas_page.dart';

class QuejasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quejas y Reclamos",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold), // Estilo del título
        ),
        centerTitle: true, // Centrar el título en la AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NuevaQuejaPage()),
                );
              },
              icon: Icon(Icons.add, size: 24), // Icono para el botón
              label: Text(
                "Generar Nueva Queja/Sugerencia",
                style: TextStyle(fontSize: 18), // Tamaño del texto
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 15), // Tamaño del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaQuejasPage()),
                );
              },
              icon: Icon(Icons.list, size: 24), // Icono para el botón
              label: Text(
                "Ver Lista de Quejas/Sugerencias",
                style: TextStyle(fontSize: 18), // Tamaño del texto
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 15), // Tamaño del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
