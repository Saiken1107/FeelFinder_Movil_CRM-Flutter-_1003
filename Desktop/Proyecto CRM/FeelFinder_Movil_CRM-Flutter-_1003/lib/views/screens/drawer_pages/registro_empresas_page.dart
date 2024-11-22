import 'package:flutter/material.dart';
import 'dart:convert'; // Para json.encode
import '../../../services/empresa_service.dart'; // Importa tu servicio

class RegistroEmpresasPage extends StatefulWidget {
  @override
  _RegistroEmpresasPageState createState() => _RegistroEmpresasPageState();
}

class _RegistroEmpresasPageState extends State<RegistroEmpresasPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _nombreClienteController =
      TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  final EmpresaService _empresaService =
      EmpresaService(); // Instancia del servicio

  // Método para registrar la empresa
  Future<void> _registrarEmpresa() async {
    final String nombre = _nombreController.text.trim();
    final String nombreCliente = _nombreClienteController.text.trim();
    final String direccion = _direccionController.text.trim();
    final String telefono = _telefonoController.text.trim();
    final String correo = _correoController.text.trim();

    if (nombre.isEmpty ||
        nombreCliente.isEmpty ||
        direccion.isEmpty ||
        telefono.isEmpty ||
        correo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, llena todos los campos.")),
      );
      return;
    }

    try {
      // Consumir el método del servicio
      await _empresaService.registrarEmpresa(
          nombre, direccion, telefono, correo, nombreCliente);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Empresa registrada exitosamente.")),
      );

      // Navegar de regreso a la lista de empresas
      Navigator.pop(context);
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar la empresa: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Empresa'),
        backgroundColor: const Color.fromARGB(255, 219, 79, 244),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre de la Empresa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nombreClienteController,
              decoration: InputDecoration(
                labelText: 'Nombre del Cliente',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _direccionController,
              decoration: InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _telefonoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _registrarEmpresa,
              icon: Icon(Icons.save),
              label: Text("Registrar"),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
