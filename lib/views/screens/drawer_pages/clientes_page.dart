import 'package:feelfinder_mobile/controllers/cliente_controller.dart';
import 'package:flutter/material.dart';


class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<Map<String, dynamic>> _clientes = [];
  final clienteController = ClienteController();

  bool _isLoading = true;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  void _loadClientes() async {
    final clientes = await clienteController.obtenerClientes();
    setState(() {
      _clientes = clientes;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _addCliente() async {
    await clienteController.insertarCliente(_nombreController.text, _correoController.text);
    _loadClientes();
    Navigator.of(context).pop();
  }

  Future<void> _updateCliente(int id) async {
    await clienteController.modificarCliente(id, _nombreController.text);
    _loadClientes();
    Navigator.of(context).pop();
  }

  void _deleteCliente(int id) async {
    await clienteController.eliminarCliente(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cliente eliminado")));
    _loadClientes();
  }

  void _showForm(int? id) {
    if (id != null) {
      final cliente = _clientes.firstWhere((cliente) => cliente['id'] == id);
      _nombreController.text = cliente['nombre'];
      _correoController.text = cliente['correoElectronico'];
    } else {
      _nombreController.clear();
      _correoController.clear();
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
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _correoController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(id == null ? 'Agregar Cliente' : 'Actualizar Cliente'),
                onPressed: () async {
                  if (id == null) {
                    await _addCliente();
                  } else {
                    await _updateCliente(id);
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
      appBar: AppBar(title: Text("Clientes")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _clientes.length,
              itemBuilder: (context, index) {
                final cliente = _clientes[index];
                return ListTile(
                  title: Text(cliente['nombre']),
                  subtitle: Text(cliente['correoElectronico']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showForm(cliente['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteCliente(cliente['id']),
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
