import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/controllers/quejas_controller.dart';

class NuevaQuejaPage extends StatefulWidget {
  @override
  _NuevaQuejaPageState createState() => _NuevaQuejaPageState();
}

class _NuevaQuejaPageState extends State<NuevaQuejaPage> {
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _nombreUsuarioController =
      TextEditingController();

  List<String> usuarios = [];
  final List<String> tiposQueja = ["Mejora", "Queja", "Error", "Sugerencias"];
  final List<String> selecionaUsuario = [
    "juan pablo",
    "Maira Martines",
    "Carmen luz",
    "Roberto Sanchez"
  ];

  String? tipoSeleccionado = "Mejora";
  String? usuarioSeleccionado;
  String? tipoSeleccionadoUsuario = "Juna pablo";
  final QuejaController _quejaController = QuejaController();

  @override
  void initState() {
    super.initState();
    // Llamada al método para cargar los usuarios al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva Queja/Sugerencia"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreUsuarioController,
              decoration: InputDecoration(
                labelText: "Buscar Usuario",
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 10),

            // Dropdown con lista de usuarios
            DropdownButtonFormField<String>(
              decoration:
                  InputDecoration(labelText: "Seleciona Usuario  Registra"),
              value: tipoSeleccionadoUsuario,
              items: selecionaUsuario.map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  tipoSeleccionadoUsuario = value;
                });
              },
            ),
            SizedBox(height: 10),

            // Dropdown con lista de usuarios
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Seleciona Usuario"),
              value: tipoSeleccionadoUsuario,
              items: selecionaUsuario.map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  tipoSeleccionadoUsuario = value;
                });
              },
            ),
            SizedBox(height: 10),

            // Selector de tipo de queja
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Tipo de Queja"),
              value: tipoSeleccionado,
              items: tiposQueja.map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  tipoSeleccionado = value;
                });
              },
            ),
            SizedBox(height: 10),

            // Campo de descripción
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: "Descripción de la Queja",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),

            // Botón de enviar
            ElevatedButton.icon(
              onPressed: () async {
                String descripcion = _descripcionController.text;

                if (usuarioSeleccionado == null || descripcion.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Por favor, complete todos los campos."),
                    ),
                  );
                  return;
                }

                try {
                  // Llamamos al método del controlador para registrar la queja
                  await _quejaController.registrarQueja(
                    1, // ID del usuario que solicita (esto debe ser dinámico)
                    1, // ID del usuario que necesita (esto también puede ser dinámico)
                    descripcion,
                    tiposQueja.indexOf(tipoSeleccionado!), // Tipo de queja
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Queja registrada con éxito."),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error al registrar la queja."),
                    ),
                  );
                }

                // Regresar a la pantalla anterior
                Navigator.pop(context);
              },
              icon: Icon(Icons.send),
              label: Text("Enviar Queja"),
            ),
          ],
        ),
      ),
    );
  }
}
