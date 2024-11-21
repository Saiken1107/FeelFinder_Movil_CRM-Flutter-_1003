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

  // Listas de usuarios y tipos de queja
  final List<Map<String, dynamic>> usuarios = [
    {"id": 1, "nombre": "Juan Pablo"},
    {"id": 2, "nombre": "Maira Martínez"},
    {"id": 3, "nombre": "Carmen Luz"},
    {"id": 4, "nombre": "Roberto Sánchez"},
  ];

  final List<Map<String, dynamic>> usuariosSolicitud = [
    {"id": 1, "nombre": "Laura Jiménez"},
    {"id": 2, "nombre": "Carlos Rodríguez"},
    {"id": 3, "nombre": "Patricia Díaz"},
    {"id": 4, "nombre": "Pedro Gómez"},
  ];

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
  }

  @override
  void dispose() {
    _descripcionController
        .dispose(); // Limpiamos el controlador cuando se destruye el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Función para obtener el nombre de un usuario por su ID
    String getUserNameById(int id, bool isSolicitante) {
      List<Map<String, dynamic>> userList =
          isSolicitante ? usuarios : usuariosSolicitud;
      return userList.firstWhere((user) => user['id'] == id)['nombre'];
    }

    // Función para obtener el tipo de queja por su ID
    String getQuejaTipoById(int id) {
      return tiposQueja.firstWhere((tipo) => tipo['id'] == id)['tipo'];
    }

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
                  getUserNameById(widget.queja['idUsuarioSolicita'], true)),
            ),
            SizedBox(height: 20),

            // Usuario que necesita ayuda
            ListTile(
              leading: Icon(Icons.person_outline, color: Colors.green),
              title: Text(
                "Usuario Necesita:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                  getUserNameById(widget.queja['idUsuarioNecesita'], false)),
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
              value:
                  _estatus, // El valor debe ser 0 o 1, asegúrate de que esté en la lista de items
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
                    // Actualizamos la queja con los nuevos datos
                    await _quejaController.actualizarQueja(
                      widget.queja['id'], // ID de la queja
                      _descripcionController
                          .text, // Nueva descripción de la queja
                      widget.queja['tipo'], // Tipo de queja
                      _estatus!, // Estatus actualizado
                      widget.queja['idUsuarioSolicita'],
                      widget.queja['idUsuarioNecesita'],
                    );

                    // Si la actualización es exitosa, mostramos un mensaje y volvemos a la página de QuejasPage
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Estatus y descripción actualizados con éxito."),
                        duration: Duration(seconds: 2), // Duración del mensaje
                      ),
                    );

                    // Regresamos a la página anterior (QuejasPage)
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error al actualizar la queja."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
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
