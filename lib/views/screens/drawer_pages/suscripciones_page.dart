import 'package:feelfinder_mobile/controllers/suscripcion_controller.dart';
import 'package:flutter/material.dart';

class SuscripcionesPage extends StatefulWidget {
  const SuscripcionesPage({Key? key}) : super(key: key);

  @override
  State<SuscripcionesPage> createState() => _SuscripcionesPageState();
}

class _SuscripcionesPageState extends State<SuscripcionesPage> {
  List<Map<String, dynamic>> _suscripciones = [];
  final suscripcionController = SuscripcionController();

  bool _isLoading = true;
  final TextEditingController _estadoController = TextEditingController();

  void _loadSuscripciones() async {
    final suscripciones = await suscripcionController.obtenerSuscripciones();
    setState(() {
      _suscripciones = suscripciones;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSuscripciones();
  }

  Future<void> _addSuscripcion() async {
    await suscripcionController.insertarSuscripcion(1, 1, DateTime.now()); // Replace with actual clienteId and planId
    _loadSuscripciones();
    Navigator.of(context).pop();
  }

  Future<void> _updateSuscripcion(int id) async {
    await suscripcionController.modificarSuscripcion(id, _estadoController.text);
    _loadSuscripciones();
    Navigator.of(context).pop();
  }

  void _deleteSuscripcion(int id) async {
    await suscripcionController.eliminarSuscripcion(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Suscripción eliminada")));
    _loadSuscripciones();
  }

  void _showForm(int? id) {
    if (id != null) {
      final suscripcion = _suscripciones.firstWhere((suscripcion) => suscripcion['id'] == id);
      _estadoController.text = suscripcion['estado'];
    } else {
      _estadoController.clear();
    }

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(id == null ? 'Agregar Suscripción' : 'Actualizar Suscripción'),
                onPressed: () async {
                  if (id == null) {
                    await _addSuscripcion();
                  } else {
                    await _updateSuscripcion(id);
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Suscripciones")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _suscripciones.length,
              itemBuilder: (context, index) {
                final suscripcion = _suscripciones[index];
                return ListTile(
                  title: Text("Suscripción ID: ${suscripcion['id']}"),
                  subtitle: Text("Estado: ${suscripcion['estado']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showForm(suscripcion['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteSuscripcion(suscripcion['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
