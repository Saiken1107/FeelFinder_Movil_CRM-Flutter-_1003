import 'package:flutter/material.dart';
import 'registro_empresas_page.dart';

class EmpresasPage extends StatelessWidget {
  final List<Map<String, String>> empresas = [
    {
      'nombre': 'Empresa 1',
      'direccion': 'Calle Ficticia 123',
      'telefono': '123456789'
    },
    {
      'nombre': 'Empresa 2',
      'direccion': 'Avenida Siempre Viva 456',
      'telefono': '987654321'
    },
    // Más empresas
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Empresas'),
      ),
      body: ListView.builder(
        itemCount: empresas.length,
        itemBuilder: (context, index) {
          final empresa = empresas[index];
          return ListTile(
            title: Text(empresa['nombre']!),
            subtitle: Text(empresa['direccion']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmpresaDetailScreen(empresa: empresa),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistroEmpresasPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: "Añadir nueva queja",
      ),
    );
  }
}

class EmpresaDetailScreen extends StatelessWidget {
  final Map<String, String> empresa;

  EmpresaDetailScreen({required this.empresa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(empresa['nombre']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dirección: ${empresa['direccion']}'),
            Text('Teléfono: ${empresa['telefono']}'),
            // Otros detalles de la empresa
          ],
        ),
      ),
    );
  }
}
