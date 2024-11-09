import 'package:feelfinder_mobile/controllers/pago_%20controller.dart';
import 'package:flutter/material.dart';

class PagosPage extends StatefulWidget {
  const PagosPage({Key? key}) : super(key: key);

  @override
  State<PagosPage> createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> {
  List<Map<String, dynamic>> _pagos = [];
  final pagoController = PagoController();

  bool _isLoading = true;
  final TextEditingController _cantidadController = TextEditingController();

  void _loadPagos() async {
    final pagos = await pagoController.obtenerPagos();
    setState(() {
      _pagos = pagos;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPagos();
  }

  Future<void> _addPago() async {
    await pagoController.insertarPago(double.parse(_cantidadController.text), DateTime.now(), 1); // Replace 1 with actual suscripcionId
    _loadPagos();
    Navigator.of(context).pop();
  }

  Future<void> _updatePago(int id) async {
    await pagoController.modificarPago(id, double.parse(_cantidadController.text));
    _loadPagos();
    Navigator.of(context).pop();
  }

  void _deletePago(int id) async {
    await pagoController.eliminarPago(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pago eliminado")));
    _loadPagos();
  }

  void _showForm(int? id) {
    if (id != null) {
      final pago = _pagos.firstWhere((pago) => pago['id'] == id);
      _cantidadController.text = pago['cantidad'].toString();
    } else {
      _cantidadController.clear();
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
                controller: _cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(id == null ? 'Agregar Pago' : 'Actualizar Pago'),
                onPressed: () async {
                  if (id == null) {
                    await _addPago();
                  } else {
                    await _updatePago(id);
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
      appBar: AppBar(title: Text("Pagos")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _pagos.length,
              itemBuilder: (context, index) {
                final pago = _pagos[index];
                return ListTile(
                  title: Text("Cantidad: ${pago['cantidad']}"),
                  subtitle: Text("Fecha: ${pago['fechaDePago']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showForm(pago['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletePago(pago['id']),
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
