import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  String? tipoSeleccionado = "Mejora";
  String? usuarioSeleccionado;

  @override
  void initState() {
    super.initState();
    obtenerUsuarios(); // Llamada al método para cargar los usuarios al iniciar
  }

  Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    var client = http.Client();
    Map<String, dynamic> body = {};

    body.addAll({
      'noDB': 'BD Encriptada',
      'idDocente': 'ID Encriptado',
      'idCE': '0 Encriptado',
    });

    try {
      http.Response response = await client.post(
        Uri.parse('http://localhost:5000/api/Account/sinToken'),
        body: jsonEncode(body), // convierte el cuerpo a JSON
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> usuariosList =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));

        // Procesa y desencripta cada usuario
        int i = 0;
        for (var usuario in usuariosList) {
          usuariosList[i]['fullName'] =
              usuario['fullName']; // Ajusta según el dato que necesites
          i++;
        }

        // Convierte explícitamente a List<String> usando map
        setState(() {
          usuarios = usuariosList
              .map<String>((usuario) => usuario['fullName'] as String)
              .toList();
        });
      } else {
        throw Exception('Error al cargar usuarios');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      client.close();
    }
    return [];
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
            // Campo de búsqueda de usuario
            TextField(
              controller: _nombreUsuarioController,
              decoration: InputDecoration(
                labelText: "Buscar Usuario",
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 10),

            // Dropdown con lista de usuarios de la API
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Seleccionar Usuario"),
              items: usuarios.map((String usuario) {
                return DropdownMenuItem<String>(
                  value: usuario,
                  child: Text(usuario),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  usuarioSeleccionado = value;
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
              onPressed: () {
                String nombreUsuario = _nombreUsuarioController.text;
                String descripcion = _descripcionController.text;

                if (usuarioSeleccionado == null || descripcion.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Por favor, complete todos los campos."),
                    ),
                  );
                  return;
                }

                print(
                    "Queja de $nombreUsuario: $descripcion (Tipo: $tipoSeleccionado)");
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
