import 'package:feelfinder_mobile/controllers/quejas_controller.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/detalle_queja_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/nueva_queja_page.dart';
import 'package:flutter/material.dart';

class Queja {
  int id;
  int idUsuarioSolicita;
  int idUsuarioNecesita;
  String descripcion;
  int estatus;
  int tipo;

  Queja({
    this.id = 0,
    required this.idUsuarioSolicita,
    required this.idUsuarioNecesita,
    required this.descripcion,
    required this.estatus,
    required this.tipo,
  });

  // Método para convertir la Queja a un Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUsuarioSolicita': idUsuarioSolicita,
      'idUsuarioNecesita': idUsuarioNecesita,
      'descripcion': descripcion,
      'estatus': estatus,
      'tipo': tipo,
    };
  }

  // Método para crear un objeto Queja a partir de un Map<String, dynamic>
  factory Queja.fromMap(Map<String, dynamic> map) {
    return Queja(
      id: map['id'] ?? 0,
      idUsuarioSolicita: map['idUsuarioSolicita'] ?? 0,
      idUsuarioNecesita: map['idUsuarioNecesita'] ?? 0,
      descripcion: map['descripcion'] ?? 'Sin descripción',
      estatus: map['estatus'] ?? 0,
      tipo: map['tipo'] ?? 0,
    );
  }
}

class QuejasPage extends StatelessWidget {
  final QuejaController _quejaController = QuejaController();

  // Mapa de estatus a texto, color y icono
  final Map<int, Map<String, dynamic>> estatusMap = {
    1: {
      "label": "Registrado",
      "color": Colors.blue,
      "icon": Icons.fiber_manual_record
    },
    2: {
      "label": "Pendiente",
      "color": Colors.orange,
      "icon": Icons.hourglass_empty
    },
    3: {
      "label": "Implementado",
      "color": Colors.green,
      "icon": Icons.check_circle
    },
    4: {"label": "Terminado", "color": Colors.purple, "icon": Icons.done_all},
    5: {"label": "Cancelado", "color": Colors.red, "icon": Icons.cancel},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Quejas/Sugerencias"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Aquí se puede agregar lógica para recargar las quejas
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Cambié el tipo de retorno a List<Map<String, dynamic>> por claridad
        future: _quejaController.obtenerQuejas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay quejas registradas.'));
          } else {
            final quejas = snapshot.data!;

            return ListView.builder(
              itemCount: quejas.length,
              itemBuilder: (context, index) {
                // Recuperamos el estatus de la queja
                final estatus = quejas[index]['estatus'] ??
                    1; // Si no hay estatus, asignamos 1 por defecto

                // Aseguramos que el estatus esté en el mapa, si no está, asignamos un valor por defecto.
                final estatusInfo = estatusMap[
                    estatus]; // Esto puede ser null si no existe el estatus

                // Si estatusInfo es null, usamos un valor por defecto
                final icono =
                    estatusInfo?['icon'] ?? Icons.help; // Icono por defecto
                final color =
                    estatusInfo?['color'] ?? Colors.grey; // Color por defecto
                final label = estatusInfo?['label'] ??
                    'Desconocido'; // Etiqueta por defecto

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: Icon(
                        icono,
                        color: color,
                        size: 40,
                      ),
                      title: Text(
                        quejas[index]['descripcion'] ?? 'Sin descripción',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            "Usuario Solicitante: ${quejas[index]['idUsuarioSolicita']}",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Estatus: $label",
                            style: TextStyle(
                              fontSize: 14,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        final queja = Queja.fromMap(quejas[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalleQuejaPage(queja: queja.toMap()),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NuevaQuejaPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: "Añadir nueva queja",
      ),
    );
  }
}
