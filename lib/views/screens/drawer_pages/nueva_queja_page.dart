import 'package:flutter/material.dart';

class NuevaQuejaPage extends StatelessWidget {
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _nombreUsuarioController =
      TextEditingController();

  // Lista de usuarios (ejemplo)
  final List<String> usuarios = [
    "Usuario 1",
    "Usuario 2",
    "Usuario 3",
    "Usuario 4"
  ];

  final List<String> tiposQueja = ["Mejora", "Queja", "Error", "Sugerencias"];
  String? tipoSeleccionado = "Mejora"; // Valor predeterminado
  String? usuarioSeleccionado; // Para almacenar el usuario seleccionado

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
              onChanged: (value) {
                // Aquí puedes implementar la lógica de filtrado si es necesario
              },
            ),
            SizedBox(height: 10),

            // Selector de usuario
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Seleccionar Usuario"),
              items: usuarios.map((String usuario) {
                return DropdownMenuItem<String>(
                  value: usuario,
                  child: Text(usuario),
                );
              }).toList(),
              onChanged: (value) {
                usuarioSeleccionado = value; // Guardar usuario seleccionado
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
                tipoSeleccionado = value; // Actualiza el tipo seleccionado
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

                // Validaciones
                if (usuarioSeleccionado == null || descripcion.isEmpty) {
                  // Aquí puedes mostrar un mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Por favor, complete todos los campos."),
                    ),
                  );
                  return; // No enviar si los campos están vacíos
                }

                // Aquí puedes agregar la lógica para guardar en la lista o base de datos
                print(
                    "Queja de $nombreUsuario: $descripcion (Tipo: $tipoSeleccionado)");

                // Volver a la página anterior
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
