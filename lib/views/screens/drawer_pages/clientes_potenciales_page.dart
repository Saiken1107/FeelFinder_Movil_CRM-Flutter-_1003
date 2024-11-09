import 'package:flutter/material.dart';

class ClientesPotencialesPage extends StatefulWidget {
  // Agregar parámetro key al constructor de StatefulWidget
  ClientesPotencialesPage({Key? key}) : super(key: key);

  @override
  _ClientesPotencialesPageState createState() =>
      _ClientesPotencialesPageState();
}

class _ClientesPotencialesPageState extends State<ClientesPotencialesPage> {
  final List<Map<String, String>> clientesPotenciales = [
    {'nombre': 'Cliente A', 'estado': 'Nuevo', 'telefono': '5551234567'},
    {
      'nombre': 'Cliente B',
      'estado': 'En seguimiento',
      'telefono': '5559876543'
    },
    // Más clientes
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes Potenciales'),
      ),
      body: ListView.builder(
        itemCount: clientesPotenciales.length,
        itemBuilder: (context, index) {
          final cliente = clientesPotenciales[index];
          return ListTile(
            title: Text(cliente['nombre'] ?? 'Nombre no disponible'),
            subtitle: Text(cliente['estado'] ?? 'Estado no disponible'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ClientePotencialDetailScreen(cliente: cliente),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ClientePotencialDetailScreen extends StatelessWidget {
  final Map<String, String> cliente;

  ClientePotencialDetailScreen({required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cliente['nombre'] ?? 'Cliente desconocido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estado: ${cliente['estado'] ?? 'Estado no disponible'}'),
            Text(
                'Teléfono: ${cliente['telefono'] ?? 'Teléfono no disponible'}'),
            // Otros detalles del cliente
          ],
        ),
      ),
    );
  }
}
