// pagos_page.dart
import 'package:feelfinder_mobile/controllers/pago_%20controller.dart';
import 'package:flutter/material.dart';

class PagosPage extends StatefulWidget {
  const PagosPage({Key? key}) : super(key: key);

  @override
  State<PagosPage> createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> {
  final PagoController _pagoController = PagoController();
  List<Map<String, dynamic>> _pagos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarPagos();
  }

  void _cargarPagos() async {
    final pagos = await _pagoController.obtenerPagos();
    setState(() {
      _pagos = pagos;
      _isLoading = false;
    });
  }

  void _mostrarFormulario({int? id}) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Cantidad'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Fecha de Pago'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text(id == null ? 'Registrar' : 'Actualizar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pagos')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _pagos.length,
              itemBuilder: (context, index) {
                final pago = _pagos[index];
                return ListTile(
                  title: Text('Cantidad: ${pago['cantidad']}'),
                  subtitle: Text('ID Suscripción: ${pago['suscripcionId']}'),
                  onTap: () => _mostrarFormulario(id: pago['id']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        child: Icon(Icons.add),
      ),
    );
  }
}
