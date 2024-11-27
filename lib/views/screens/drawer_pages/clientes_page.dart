// clientes_page.dart
import 'package:feelfinder_mobile/controllers/cliente_controller.dart';
import 'package:flutter/material.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key}) : super(key: key);

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<Map<String, dynamic>> _clientes = [];
  final clienteController = ClienteController();

  bool _isLoading = true;
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  void _loadClientes() async {
    try {
      final clientes = await clienteController.obtenerClientes();
      setState(() {
        _clientes = clientes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError("Error al cargar clientes: $e");
    }
  }

  Future<void> _addCliente() async {
    if (_validateForm()) {
      try {
        await clienteController.registrarCliente(
          _correoController.text,
          _nombreController.text,
          _apellidoController.text,
        );
        _loadClientes();
        Navigator.of(context).pop();
        _showSuccess("Cliente agregado exitosamente.");
      } catch (e) {
        _showError("No se pudo registrar el cliente: $e");
      }
    }
  }

  Future<void> _updateCliente(int id) async {
    if (_validateForm()) {
      try {
        await clienteController.actualizarCliente(
          id,
          _correoController.text,
          _nombreController.text,
          _apellidoController.text,
        );
        _loadClientes();
        Navigator.of(context).pop();
        _showSuccess("Cliente actualizado exitosamente.");
      } catch (e) {
        _showError("No se pudo actualizar el cliente: $e");
      }
    }
  }

  bool _validateForm() {
    if (_correoController.text.isEmpty ||
        _nombreController.text.isEmpty ||
        _apellidoController.text.isEmpty) {
      _showError("Todos los campos son obligatorios.");
      return false;
    }
    return true;
  }

  void _deleteCliente(int id) async {
    try {
      await clienteController.eliminarCliente(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cliente eliminado")),
      );
      _loadClientes();
    } catch (e) {
      _showError("No se pudo eliminar el cliente: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showForm({int? id, bool isViewing = false}) {
    if (id != null) {
      final cliente = _clientes.firstWhere((cliente) => cliente['id'] == id);
      _correoController.text = cliente['correoElectronico'];
      _nombreController.text = cliente['nombre'];
      _apellidoController.text = cliente['apellido'];
    } else {
      _correoController.clear();
      _nombreController.clear();
      _apellidoController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isViewing
                      ? 'Detalles del Cliente'
                      : (id == null ? 'Agregar Cliente' : 'Actualizar Cliente'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _correoController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: isViewing,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: isViewing,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _apellidoController,
                  decoration: InputDecoration(
                    labelText: 'Apellido',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: isViewing,
                ),
                if (!isViewing) ...[
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(
                        id == null ? 'Agregar Cliente' : 'Actualizar Cliente'),
                    onPressed: () async {
                      if (id == null) {
                        await _addCliente();
                      } else {
                        await _updateCliente(id);
                      }
                    },
                  ),
                ],
              ],
            ),
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
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _clientes.length,
                itemBuilder: (context, index) {
                  final cliente = _clientes[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        cliente['nombre'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(cliente['correoElectronico']),
                      onTap: () =>
                          _showForm(id: cliente['id'], isViewing: true),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showForm(id: cliente['id']),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCliente(cliente['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        label: Text("Agregar"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
