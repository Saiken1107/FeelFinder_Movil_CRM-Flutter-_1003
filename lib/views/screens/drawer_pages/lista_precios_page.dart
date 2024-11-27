import 'package:feelfinder_mobile/controllers/lista_precios_controller.dart';
import 'package:flutter/material.dart';

class ListaPreciosPage extends StatefulWidget {
  @override
  _ListaPreciosPageState createState() => _ListaPreciosPageState();
}

class _ListaPreciosPageState extends State<ListaPreciosPage> {
  final ListaPreciosController _controller = ListaPreciosController();
  List<Map<String, dynamic>> _listasPrecios = [];
  bool _isLoading = true;

  final TextEditingController _tipoPlanController = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();
  final TextEditingController _precioPlanController = TextEditingController();
  final TextEditingController _cantidadLicenciasController = TextEditingController();
  final TextEditingController _duracionContratoController = TextEditingController();
  final TextEditingController _precioFinalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadListasPrecios();
  }

  void _loadListasPrecios() async {
    try {
      final listas = await _controller.obtenerListasPrecios();
      setState(() {
        _listasPrecios = listas;
        _isLoading = false;
      });
    } catch (e) {
      _showError("Error al cargar las listas de precios: $e");
    }
  }

  Future<void> _crearOActualizarListaPrecios({int? id}) async {
    final listaPrecios = {
      "tipoPlan": _tipoPlanController.text,
      "precioPlan": double.parse(_precioPlanController.text),
      "empresa": _empresaController.text,
      "cantidadLicencias": int.parse(_cantidadLicenciasController.text),
      "duracionContrato": int.parse(_duracionContratoController.text),
      "precioFinal": double.parse(_precioFinalController.text),
    };

    try {
      if (id == null) {
        await _controller.crearListaPrecios(listaPrecios);
      } else {
        await _controller.actualizarListaPrecios(id, listaPrecios);
      }
      _loadListasPrecios();
      Navigator.pop(context);
    } catch (e) {
      _showError("Error al guardar la lista de precios: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showForm({int? id}) {
    if (id != null) {
      final lista = _listasPrecios.firstWhere((item) => item['id'] == id);
      _tipoPlanController.text = lista['tipoPlan'];
      _precioPlanController.text = lista['precioPlan'].toString();
      _empresaController.text = lista['empresa'];
      _cantidadLicenciasController.text = lista['cantidadLicencias'].toString();
      _duracionContratoController.text = lista['duracionContrato'].toString();
      _precioFinalController.text = lista['precioFinal'].toString();
    } else {
      _tipoPlanController.clear();
      _precioPlanController.clear();
      _empresaController.clear();
      _cantidadLicenciasController.clear();
      _duracionContratoController.clear();
      _precioFinalController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _tipoPlanController, decoration: InputDecoration(labelText: 'Tipo de Plan')),
              TextField(controller: _precioPlanController, decoration: InputDecoration(labelText: 'Precio Plan'), keyboardType: TextInputType.number),
              TextField(controller: _empresaController, decoration: InputDecoration(labelText: 'Empresa')),
              TextField(controller: _cantidadLicenciasController, decoration: InputDecoration(labelText: 'Cantidad Licencias'), keyboardType: TextInputType.number),
              TextField(controller: _duracionContratoController, decoration: InputDecoration(labelText: 'Duración Contrato (meses)'), keyboardType: TextInputType.number),
              TextField(controller: _precioFinalController, decoration: InputDecoration(labelText: 'Precio Final'), keyboardType: TextInputType.number),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _crearOActualizarListaPrecios(id: id),
                child: Text(id == null ? 'Crear' : 'Actualizar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _eliminarListaPrecios(int id) async {
    try {
      await _controller.eliminarListaPrecios(id);
      _loadListasPrecios();
    } catch (e) {
      _showError("Error al eliminar la lista de precios: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Precios")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listasPrecios.length,
              itemBuilder: (context, index) {
                final lista = _listasPrecios[index];
                return ListTile(
                  title: Text(lista['tipoPlan']),
                  subtitle: Text("Empresa: ${lista['empresa']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showForm(id: lista['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _eliminarListaPrecios(lista['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
