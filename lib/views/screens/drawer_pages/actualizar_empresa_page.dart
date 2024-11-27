import 'package:flutter/material.dart';
import '../../../services/empresa_service.dart';

class ActualizarEmpresaPage extends StatefulWidget {
  final Map<String, dynamic> empresa;

  ActualizarEmpresaPage({required this.empresa});

  @override
  _ActualizarEmpresaPageState createState() => _ActualizarEmpresaPageState();
}

class _ActualizarEmpresaPageState extends State<ActualizarEmpresaPage> {
  final EmpresaService _empresaService = EmpresaService();

  // Controladores para los campos del formulario
  late TextEditingController _nombreEmpresaController;
  late TextEditingController _direccionController;
  late TextEditingController _telefonoController;
  late TextEditingController _correoController;
  late TextEditingController _nombreClienteController;

  int? _estatus; // Estatus de la empresa

  @override
  void initState() {
    super.initState();

    // Inicializar los controladores con los datos de la empresa seleccionada
    _nombreEmpresaController =
        TextEditingController(text: widget.empresa['nombreEmpresa']);
    _direccionController =
        TextEditingController(text: widget.empresa['direccion']);
    _telefonoController =
        TextEditingController(text: widget.empresa['telefono']);
    _correoController = TextEditingController(text: widget.empresa['correo']);
    _nombreClienteController =
        TextEditingController(text: widget.empresa['nombreCliente']);
    _estatus = widget.empresa['estatus'] ?? 1;
  }

  @override
  void dispose() {
    // Limpiar los controladores
    _nombreEmpresaController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _nombreClienteController.dispose();
    super.dispose();
  }

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

    // Eliminar espacios adicionales en los demás campos
    _nombreEmpresaController.text = _nombreEmpresaController.text.trim();
    _direccionController.text = _direccionController.text.trim();
    _nombreClienteController.text = _nombreClienteController.text.trim();

    return true;
  }

  Future<void> _actualizarEmpresa() async {
    if (!_validarFormulario()) return;

    try {
      await _empresaService.actualizarEmpresa(
        widget.empresa['id'],
        _nombreClienteController.text,
        _direccionController.text,
        _telefonoController.text.replaceAll(' ', ''), // Eliminar espacios
        _correoController.text.trim(), // Eliminar espacios
        _nombreEmpresaController.text,
        _estatus!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Empresa actualizada con éxito')),
      );

      // Regresar a la lista de empresas
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la empresa')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualizar Empresa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de texto para el nombre de la empresa
              TextFormField(
                controller: _nombreEmpresaController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Empresa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              SizedBox(height: 15),

              // Campo de texto para la dirección
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              SizedBox(height: 15),

              // Campo de texto para el teléfono
              TextFormField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 15),

              // Campo de texto para el correo
              TextFormField(
                controller: _correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 15),

              // Campo de texto para el nombre del cliente
              TextFormField(
                controller: _nombreClienteController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Cliente',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 15),

              // Dropdown para el estatus
              DropdownButtonFormField<int>(
                value: _estatus,
                items: [
                  DropdownMenuItem(value: 1, child: Text("Activo")),
                  DropdownMenuItem(value: 0, child: Text("Inactivo")),
                ],
                decoration: InputDecoration(
                  labelText: "Estatus",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.check_circle),
                ),
                onChanged: (value) {
                  setState(() {
                    _estatus = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Botón para actualizar la empresa
              ElevatedButton(
                onPressed: _actualizarEmpresa,
                child: Text("Actualizar Empresa"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
