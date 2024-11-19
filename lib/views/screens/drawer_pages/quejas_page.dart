import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/controllers/quejas_controller.dart';
import 'nueva_queja_page.dart';

// Mover la clase Queja fuera de QuejasPage
class Queja {
  int id;
  int idUsuarioSolicita;
  int idUsuarioNecesita;
  String descripcion;
  int estatus;
  int tipo;

  Queja({
    this.id = 0,
    required this.idUsuarioNecesita,
    required this.idUsuarioSolicita,
    required this.descripcion,
    required this.estatus,
    required this.tipo,
  });
}

class QuejasPage extends StatelessWidget {
  final QuejaController _quejaController = QuejaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Quejas/Sugerencias"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Aquí deberías tener la lógica para obtener datos
        future: _quejaController
            .obtenerQuejas(), // Consumimos el método para obtener las quejas
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Muestra un indicador de carga
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // Muestra el error si ocurre
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No hay quejas registradas.')); // Si no hay datos
          } else {
            final quejas = snapshot.data!;

            return ListView.builder(
              itemCount: quejas.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        quejas[index]['descripcion'] ?? 'Sin descripción',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                              "Usuario: ${quejas[index]['idUsuarioSolicita']}"),
                          Text("Estatus: ${quejas[index]['descripcion']}"),
                        ],
                      ),
                      onTap: () {
                        // Código para navegar a los detalles de la queja si es necesario
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
