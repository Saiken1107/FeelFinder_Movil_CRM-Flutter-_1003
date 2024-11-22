import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/controllers/quejas_controller.dart';

class NuevaQuejaPage extends StatefulWidget {
  @override
  _NuevaQuejaPageState createState() => _NuevaQuejaPageState();
}

class _NuevaQuejaPageState extends State<NuevaQuejaPage> {
  final TextEditingController _descripcionController = TextEditingController();

  // Lista de usuarios con un ID y nombre (quien registra la queja)
  List<Map<String, dynamic>> usuarios = [];

  // Lista de usuarios con un ID y nombre (usuario al que se le hace la solicitud)
  List<Map<String, dynamic>> usuariosSolicitud = [];

  // Lista de tipos de queja con un ID
  final List<Map<String, dynamic>> tiposQueja = [
    {"id": 1, "tipo": "Mejora"},
    {"id": 2, "tipo": "Queja"},
    {"id": 3, "tipo": "Error"},
    {"id": 4, "tipo": "Sugerencias"},
  ];

  int? idUsuarioSeleccionado;
  int? idUsuarioSolicitudSeleccionado;
  int? idTipoSeleccionado = 1;

  final QuejaController _quejaController = QuejaController();

  @override
  void initState() {
    super.initState();
    _loadUsuarios(); // Cargar usuarios al iniciar la página
  }

  Future<void> _loadUsuarios() async {
    try {
      // Llamar al controlador para obtener la lista de profesionales
      final profesionales = await _quejaController.obtenerProfesionales();

      // Extraer los datos de persona y llenar las listas
      final personas = profesionales
          .where((profesional) => profesional['persona'] != null)
          .map((profesional) => {
                "id": profesional['persona']['id'],
                "nombre":
                    "${profesional['persona']['nombre']} ${profesional['persona']['apellido']}"
              })
          .toList();

      setState(() {
        usuarios = personas;
        usuariosSolicitud = personas;
      });
    } catch (e) {
      // Manejo de errores
      print("Error al cargar los usuarios: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar usuarios")),
      );
    }
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
            // Dropdown con lista de usuarios (quien registra la queja)
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: "Selecciona Usuario Registra",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              value: idUsuarioSeleccionado,
              items: usuarios.map((usuario) {
                return DropdownMenuItem<int>(
                  value: usuario['id'],
                  child: Text(usuario['nombre']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  idUsuarioSeleccionado = value;
                });
              },
            ),
            SizedBox(height: 15),

            // Dropdown con lista de usuarios al que se le hace la solicitud
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: "Selecciona Usuario de Solicitud",
                prefixIcon: Icon(Icons.supervised_user_circle),
                border: OutlineInputBorder(),
              ),
              value: idUsuarioSolicitudSeleccionado,
              items: usuariosSolicitud.map((usuario) {
                return DropdownMenuItem<int>(
                  value: usuario['id'],
                  child: Text(usuario['nombre']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  idUsuarioSolicitudSeleccionado = value;
                });
              },
            ),
            SizedBox(height: 15),

            // Dropdown con lista de tipos de queja (con ID)
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: "Tipo de Queja",
                prefixIcon: Icon(Icons.report_problem),
                border: OutlineInputBorder(),
              ),
              value: idTipoSeleccionado,
              items: tiposQueja.map((tipo) {
                return DropdownMenuItem<int>(
                  value: tipo['id'],
                  child: Text(tipo['tipo']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  idTipoSeleccionado = value;
                });
              },
            ),
            SizedBox(height: 15),

            // Campo de descripción
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: "Descripción de la Queja",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),

            // Botón de enviar
            ElevatedButton.icon(
              onPressed: () async {
                String descripcion = _descripcionController.text;

                if (idUsuarioSeleccionado == null ||
                    idUsuarioSolicitudSeleccionado == null ||
                    descripcion.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Por favor, complete todos los campos."),
                    ),
                  );
                  return;
                }

                try {
                  // Llamar al método del controlador para registrar la queja
                  await _quejaController.registrarQueja(
                    idUsuarioSeleccionado!,
                    idUsuarioSolicitudSeleccionado!,
                    descripcion,
                    idTipoSeleccionado!,
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
