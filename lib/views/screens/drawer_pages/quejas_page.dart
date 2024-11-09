import 'package:flutter/material.dart';
import 'nueva_queja_page.dart';

class QuejasPage extends StatelessWidget {
  final List<Queja> quejas = [
    Queja(
      nombreUsuario: 'Usuario 1',
      estatus: 'Pendiente',
      descripcion: 'Descripción de la queja 1',
      tipoSuscripcion: 'Tipo A',
      imagenUrl: 'https://via.placeholder.com/150',
    ),
    Queja(
      nombreUsuario: 'Usuario 2',
      estatus: 'Solucionado',
      descripcion: 'Descripción de la queja 2',
      tipoSuscripcion: 'Tipo B',
      imagenUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Quejas/Sugerencias"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: quejas.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
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
                    SizedBox(height: 5),
                    Text("Usuario: ${quejas[index].nombreUsuario}"),
                    Text("Estatus: ${quejas[index].estatus}"),
                  ],
                ),
                onTap: () {
                  // Código para navegar a los detalles de la queja si es necesario
                },
              ),
            ),
          );
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

class Queja {
  String nombreUsuario;
  String estatus;
  String descripcion;
  String tipoSuscripcion;
  String? imagenUrl;

  Queja({
    required this.nombreUsuario,
    required this.estatus,
    required this.descripcion,
    required this.tipoSuscripcion,
    this.imagenUrl,
  });
}
