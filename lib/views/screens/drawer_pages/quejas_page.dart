import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/controllers/quejas_controller.dart';
import 'nueva_queja_page.dart';
import 'detalle_queja_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Quejas/Sugerencias"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
                          Text("Estatus: ${quejas[index]['estatus']}"),
                        ],
                      ),
                      onTap: () {
                        final queja = Queja.fromMap(quejas[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalleQuejaPage(queja: queja),
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
