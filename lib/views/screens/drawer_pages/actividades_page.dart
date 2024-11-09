import 'package:flutter/material.dart';

class ActividadesPage extends StatelessWidget {
  final List<Map<String, String>> actividades = [
    {'actividad': 'Llamar al cliente A', 'estado': 'Pendiente'},
    {'actividad': 'Enviar propuesta a cliente B', 'estado': 'En progreso'},
    // Más actividades
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Actividades'),
      ),
      body: ListView.builder(
        itemCount: actividades.length,
        itemBuilder: (context, index) {
          final actividad = actividades[index];
          return ListTile(
            title: Text(actividad['actividad']!),
            subtitle: Text(actividad['estado']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ActividadDetailScreen(actividad: actividad),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ActividadDetailScreen extends StatelessWidget {
  final Map<String, String> actividad;

  ActividadDetailScreen({required this.actividad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(actividad['actividad']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estado: ${actividad['estado']}'),
            // Otros detalles de la actividad
          ],
        ),
      ),
    );
  }
}
