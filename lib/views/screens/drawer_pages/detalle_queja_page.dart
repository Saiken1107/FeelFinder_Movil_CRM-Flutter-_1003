import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/controllers/quejas_controller.dart';

class DetalleQuejaPage extends StatefulWidget {
  final Map<String, dynamic> queja; // Usamos un Map en lugar de un modelo

  DetalleQuejaPage({required this.queja});

  @override
  _DetalleQuejaPageState createState() => _DetalleQuejaPageState();
}

class _DetalleQuejaPageState extends State<DetalleQuejaPage> {
  final QuejaController _quejaController = QuejaController();
  int? _estatus;
  late TextEditingController _descripcionController;

  // Listas de usuarios dinámicas
  List<Map<String, dynamic>> usuarios = [];
  List<Map<String, dynamic>> usuariosSolicitud = [];

  // Lista estática de tipos de queja
  final List<Map<String, dynamic>> tiposQueja = [
    {"id": 1, "tipo": "Mejora"},
    {"id": 2, "tipo": "Queja"},
    {"id": 3, "tipo": "Error"},
    {"id": 4, "tipo": "Sugerencias"},
  ];

  @override
  void initState() {
    super.initState();
    _estatus =
        widget.queja['estatus']; // Inicializamos el estatus desde el mapa
    _descripcionController =
        TextEditingController(text: widget.queja['descripcion']);
    _loadUsuarios(); // Cargar usuarios al iniciar la página
  }

  @override
  void dispose() {
    _descripcionController
        .dispose(); // Limpiamos el controlador cuando se destruye el widget
    super.dispose();
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

  // Función para obtener el nombre de un usuario por su ID
  String getUserNameById(int id, List<Map<String, dynamic>> userList) {
    try {
      return userList.firstWhere((user) => user['id'] == id)['nombre'];
    } catch (e) {
      return "Desconocido"; // Valor por defecto si no se encuentra
    }
  }

  // Función para obtener el tipo de queja por su ID
  String getQuejaTipoById(int id) {
    return tiposQueja.firstWhere((tipo) => tipo['id'] == id)['tipo'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle de la Queja"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usuario solicitante
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text(
                "Usuario Solicitante:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                  getUserNameById(widget.queja['idUsuarioSolicita'], usuarios)),
            ),
            SizedBox(height: 20),

            // Usuario que necesita ayuda
            ListTile(
              leading: Icon(Icons.person_outline, color: Colors.green),
              title: Text(
                "Usuario Necesita:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(getUserNameById(
                  widget.queja['idUsuarioNecesita'], usuariosSolicitud)),
            ),
            SizedBox(height: 20),

            // Tipo de queja
            ListTile(
              leading: Icon(Icons.comment, color: Colors.orange),
              title: Text(
                "Tipo de Queja:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(getQuejaTipoById(widget.queja['tipo'])),
            ),
            SizedBox(height: 20),

            // Descripción de la queja
            Text(
              "Descripción:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            // Campo editable para la descripción
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa una nueva descripción',
                prefixIcon: Icon(Icons.edit),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),

            // Estatus de la queja (Pendiente/Resuelto)
            Text(
              "Estatus:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Selecciona Estatus",
                prefixIcon: Icon(Icons.check_circle_outline),
              ),
              value: _estatus,
              items: [
                DropdownMenuItem<int>(value: 1, child: Text("Registro")),
                DropdownMenuItem<int>(value: 2, child: Text("Pendiente")),
                DropdownMenuItem<int>(value: 3, child: Text("Implementacion")),
                DropdownMenuItem<int>(value: 4, child: Text("Terminado")),
                DropdownMenuItem<int>(value: 5, child: Text("Cancelado")),
              ],
              onChanged: (value) {
                setState(() {
                  _estatus = value; // Actualiza el valor seleccionado
                });
              },
            ),

            SizedBox(height: 20),

            // Botón para guardar cambios
            ElevatedButton.icon(
              onPressed: () async {
                if (_estatus != null &&
                    _descripcionController.text.isNotEmpty) {
                  try {
                    await _quejaController.actualizarQueja(
                      widget.queja['id'],
                      _descripcionController.text,
                      widget.queja['tipo'],
                      _estatus!,
                      widget.queja['idUsuarioSolicita'],
                      widget.queja['idUsuarioNecesita'],
                    );

                    // Muestra el SnackBar antes de navegar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Estatus y descripción actualizados con éxito."),
                      ),
                    );

                    // Retrasa la navegación para evitar el error
                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.pop(context, true);
                    });
                  } catch (e) {
                    // Manejo de errores
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error al actualizar la queja."),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Por favor, complete todos los campos."),
                    ),
                  );
                  return;
                }
              },
              icon: Icon(Icons.save),
              label: Text("Guardar Estatus y Descripción"),
            ),
          ],
        ),
      ),
    );
  }
}
