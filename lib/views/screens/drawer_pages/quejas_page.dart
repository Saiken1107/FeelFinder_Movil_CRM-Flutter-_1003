import 'package:flutter/material.dart';

class QuejasPage extends StatelessWidget {
  final List<Queja> quejas = []; // Lista simulada de quejas

  // Método simulado para cargar quejas (deberías reemplazar esto con la lógica real)
  void _loadQuejas() {
    quejas.add(Queja(
      nombreUsuario: 'Usuario 1',
      estatus: 'Pendiente',
      descripcion: 'Descripción de la queja 1',
      tipoSuscripcion: 'Tipo A',
      imagenUrl: 'https://via.placeholder.com/150', // URL de imagen de ejemplo
    ));
    // Agrega más quejas según sea necesario
  }

  // Método para mostrar el diálogo de edición de queja
  void _showEditDialog(BuildContext context, int index) {
    final TextEditingController _solucionController = TextEditingController();
    String nuevoEstatus = quejas[index].estatus;
    DateTime? fechaCita;
    TimeOfDay? horaCita;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Queja"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Descripción: ${quejas[index].descripcion}"),
              Text("Usuario: ${quejas[index].nombreUsuario}"),
              Text("Estatus: $nuevoEstatus"),
              SizedBox(height: 10),
              TextField(
                controller: _solucionController,
                decoration: InputDecoration(labelText: "Solución"),
              ),
              DropdownButton<String>(
                value: nuevoEstatus,
                items: <String>['Pendiente', 'Resuelto']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  nuevoEstatus = newValue!;
                },
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  // Seleccionar fecha
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: fechaCita ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    fechaCita = picked; // Asignar fecha seleccionada
                  }
                },
                child: Text(
                  fechaCita == null
                      ? 'Seleccionar Fecha'
                      : 'Fecha: ${fechaCita!.toLocal()}'.split(' ')[0],
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Seleccionar hora
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: horaCita ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    horaCita = picked; // Asignar hora seleccionada
                  }
                },
                child: Text(
                  horaCita == null
                      ? 'Seleccionar Hora'
                      : 'Hora: ${horaCita!.format(context)}',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Aquí iría la lógica para enviar el correo
                // y actualizar el estatus y solución
                print(
                    "Correo enviado con solución: ${_solucionController.text}");
                // Actualizar estatus en la lista de quejas
                quejas[index].estatus = nuevoEstatus;
                quejas[index].solucion = _solucionController
                    .text; // Asegúrate de agregar un campo de solución en la clase Queja
                if (fechaCita != null && horaCita != null) {
                  final DateTime fechaCompleta = DateTime(
                    fechaCita!.year,
                    fechaCita!.month,
                    fechaCita!.day,
                    horaCita!.hour,
                    horaCita!.minute,
                  );
                  quejas[index].fechaCita =
                      fechaCompleta; // Asegúrate de agregar un campo de fechaCita en la clase Queja
                }
                Navigator.of(context).pop();
              },
              child: Text("Enviar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadQuejas(); // Cargar quejas al construir la página

    return Scaffold(
      appBar: AppBar(
        title: Text("Quejas y Reclamos"),
      ),
      body: ListView.builder(
        itemCount: quejas.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(10.0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(quejas[index].imagenUrl!),
                radius: 30,
              ),
              title: Text(
                quejas[index].descripcion,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Usuario: ${quejas[index].nombreUsuario}"),
                  Text("Estatus: ${quejas[index].estatus}"),
                  Text("Tipo de Suscripción: ${quejas[index].tipoSuscripcion}"),
                  if (quejas[index].fechaCita != null)
                    Text("Fecha de Cita: ${quejas[index].fechaCita}"),
                ],
              ),
              onTap: () => _showEditDialog(
                  context, index), // Muestra el diálogo al tocar la queja
            ),
          );
        },
      ),
    );
  }
}

class Queja {
  String nombreUsuario;
  String estatus;
  String descripcion;
  String tipoSuscripcion;
  String? solucion; // Campo para almacenar la solución
  DateTime? fechaCita; // Campo para almacenar la fecha de la cita
  String? imagenUrl; // Campo para almacenar la URL de la imagen

  Queja({
    required this.nombreUsuario,
    required this.estatus,
    required this.descripcion,
    required this.tipoSuscripcion,
    this.solucion,
    this.fechaCita,
    this.imagenUrl,
  });
}
