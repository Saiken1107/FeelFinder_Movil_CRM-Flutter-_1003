import 'package:flutter/material.dart';

class ListaQuejasPage extends StatelessWidget {
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
    // Puedes agregar más quejas simuladas aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Quejas/Sugerencias"),
      ),
      body: ListView.builder(
        itemCount: quejas.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(quejas[index].imagenUrl!),
                radius: 30,
              ),
              title: Text(
                quejas[index].descripcion,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Usuario: ${quejas[index].nombreUsuario}"),
              onTap: () {
                // Navegar a la página de detalles de la queja
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetalleQuejaPage(queja: quejas[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetalleQuejaPage extends StatefulWidget {
  final Queja queja;

  DetalleQuejaPage({required this.queja});

  @override
  _DetalleQuejaPageState createState() => _DetalleQuejaPageState();
}

class _DetalleQuejaPageState extends State<DetalleQuejaPage> {
  String? nuevoEstatus;

  @override
  void initState() {
    super.initState();
    nuevoEstatus = widget.queja.estatus; // Establece el estatus inicial
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de la Queja"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.queja.imagenUrl!),
              radius: 50,
            ),
            SizedBox(height: 16),
            Text("Descripción: ${widget.queja.descripcion}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Usuario: ${widget.queja.nombreUsuario}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Estatus: $nuevoEstatus", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Cambiar Estatus:", style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: nuevoEstatus,
              onChanged: (String? newValue) {
                setState(() {
                  nuevoEstatus = newValue; // Actualiza el estatus
                });
              },
              items: <String>[
                'Pendiente',
                'Solucionado',
                'Revisión',
                'Rechazado'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Campo de descripción
            TextField(
              decoration: InputDecoration(
                labelText: "Descripción de la Queja",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar lógica para guardar el nuevo estatus
                print("Estatus de la queja cambiado a: $nuevoEstatus");
                Navigator.pop(context); // Volver a la lista de quejas
              },
              child: Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }
}

class Queja {
  String nombreUsuario;
  String estatus;
  String descripcion;
  String tipoSuscripcion;
  String? imagenUrl; // Campo para almacenar la URL de la imagen

  Queja({
    required this.nombreUsuario,
    required this.estatus,
    required this.descripcion,
    required this.tipoSuscripcion,
    this.imagenUrl,
  });
}
