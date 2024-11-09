import 'package:flutter/material.dart';

class RegistroEmpresasPage extends StatefulWidget {
  @override
  _RegistroEmpresasPageState createState() => _RegistroEmpresasPageState();
}

class _RegistroEmpresasPageState extends State<RegistroEmpresasPage> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _direccion = '';
  String _telefono = '';

  @override
  Widget build(BuildContext context) {
    // Usamos MediaQuery para obtener el tamaño de la pantalla y adaptarlo
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Empresa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(
            screenWidth * 0.05), // Usa el 5% del ancho de pantalla como padding
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Hace la pantalla desplazable para pantallas pequeñas
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  onSaved: (value) => _nombre = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02), // Espaciado entre campos
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Dirección',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  onSaved: (value) => _direccion = value!,
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  onSaved: (value) => _telefono = value!,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(
                    height: screenHeight *
                        0.05), // Espaciado entre los campos y el botón
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Guardar empresa en la base de datos o almacenamiento
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registrando empresa...')));
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Registrar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.8,
                        50), // Asegura que el botón tenga buen tamaño
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
