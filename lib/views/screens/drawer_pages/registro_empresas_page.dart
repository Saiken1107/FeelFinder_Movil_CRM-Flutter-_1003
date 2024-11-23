import 'package:flutter/material.dart';
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

  bool _validarFormulario() {
    // Validar teléfono: solo números y sin espacios
    String telefono = _telefonoController.text.replaceAll(' ', '');
    if (telefono.isEmpty || !RegExp(r'^\d+$').hasMatch(telefono)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El teléfono debe contener solo números')),
      );
      return false;
    }

    // Validar correo: formato válido
    String correo = _correoController.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(correo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingrese un correo válido')),
      );
      return false;
    }

    // Verificar que todos los campos estén completos
    if (_nombreController.text.trim().isEmpty ||
        _nombreClienteController.text.trim().isEmpty ||
        _direccionController.text.trim().isEmpty ||
        telefono.isEmpty ||
        correo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, llena todos los campos.")),
      );
      return false;
    }

    // Eliminar espacios adicionales en los demás campos
    _nombreController.text = _nombreController.text.trim();
    _nombreClienteController.text = _nombreClienteController.text.trim();
    _direccionController.text = _direccionController.text.trim();

    return true;
  }

  Future<void> _registrarEmpresa() async {
    if (!_validarFormulario()) return;

    try {
      // Consumir el método del servicio
      await _empresaService.registrarEmpresa(
        _nombreController.text,
        _direccionController.text,
        _telefonoController.text.replaceAll(' ', ''), // Eliminar espacios
        _correoController.text.trim(), // Eliminar espacios
        _nombreClienteController.text,
      );

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
      appBar: AppBar(title: Text('Registrar Empresa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  prefixIcon: Icon(Icons.person),
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
      ),
    );
  }
}
